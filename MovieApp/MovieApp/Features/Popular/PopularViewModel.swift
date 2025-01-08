//
//  PopularViewModel.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine
import CombineExt

enum ViewMode: Hashable {
    case view
    case search

    var isSearch: Bool {
        return self == .search
    }

    var isView: Bool {
        return self == .view
    }
}

protocol IPopularViewModel {
    var items: Int { get }
    var sortingOption: MovieSortingOption { get }
    func model(for indexPath: IndexPath) -> Movie
}

final class PopularViewModel {
    @Inject()
    private var monitor: IConnectionMonitor

    private unowned let view: PopularView

    private let activityIndicator = ActivityIndicator()

    private let refreshIndicator = ActivityIndicator()

    private var data: [Movie]

    private var storage = DisposeStorage()

    private var _action = PassthroughSubject<PopularNavigationAction, Never>()

    private var sortOption = CurrentValueSubject<MovieSortingOption, Never>(.popularityDesc)

    private var viewMode = CurrentValueSubject<ViewMode, Never>(.view)

    private var isRefreshing: Bool = false

    private let popularPaginator = PaginationRepository<Movie, Void>()

    private let searchPaginator = PaginationRepository<Movie, String?>()

    init(view: PopularView) {
        self.view = view
        data = []

        // Note: There is a bug because the UIState is first updated,
        // and after that, the request begins
        view.sortActionTrigger
            .removeDuplicates()
            .weakAssign(to: \.sortOption, on: self)
            .store(in: &storage)

        sortOption.sink { [weak self] _ in
            self?.updateData()
        }
        .store(in: &storage)

        let isReachable = monitor.onConnectionStatus.map { $0.isReachable }

        let modeNetwork = isReachable.combineLatest(viewMode)

        modeNetwork
            .bind(to: view.disable) { $0 && $1.isView }
            .store(in: &storage)

        let textTrigger = view.searchTextTrigger
            .removeDuplicates()
            .withLatestFrom(isReachable) { ($0, $1) }
            .filter { $0.1 }
            .map { $0.0 }
            .debounce(for: debounce, scheduler: OperationQueue.main)

        textTrigger
            .weakMap(to: \.viewMode, on: self) { $0.viewMode }
            .sink { [weak self] in
                if $0.viewMode == .search {
                    self?.updateSearchData($0)
                } else {
                    self?.popularPaginator.publish()
                }
            }
            .store(in: &storage)

        let loader = view.loadTrigger
            .combineLatest(view.loadNextTrigger)
            .mapToVoid()

        let loaderWithMode = loader.withLatestFrom(viewMode, isReachable) { ($1) }
            .filter { $0.1 }
            .map { $0.0 }

        loaderWithMode
            .filter { $0.isView }
            .sink { [weak self] _ in
                self?.popularPaginator.loadNextPage()
            }
            .store(in: &storage)

        loaderWithMode
            .withLatestFrom(textTrigger) { ($0, $1) }
            .filter { $0.0.isSearch }
            .sink { [weak self] _, text in
                self?.searchPaginator.loadNextPage(text)
            }
            .store(in: &storage)

        view.refreshTrigger
            .withLatestFrom(viewMode) { $1 }
            .filter { $0 == .view }
            .mapValue { [weak self] _ in
                self?.isRefreshing = true
                self?.updateData()
            }
            .sink(receiveCompletion: { [weak self] _ in
                self?.isRefreshing = false
            }, receiveValue: { [weak self] _ in
                self?.isRefreshing = false
            })
            .store(in: &storage)

        view.didSelectRowTrigger
            .map(self) { $0.data[$1] }
            .weakAssign(to: \._action, on: self, { .open($0) })
            .store(in: &storage)

        bindingActivityIndicator(refreshIndicator, to: view.isRefreshing)

        bindingActivityIndicator(activityIndicator, to: view.isLoading)

        bindingDataPublisher(popularPaginator, mode: .view)

        bindingDataPublisher(searchPaginator, mode: .search)

        setupBindings { [weak self] in
            guard let this = self else { return nil }

            return this.isRefreshing ? this.refreshIndicator : this.activityIndicator
        }
    }

    private func setupBindings(_ activity: @escaping () -> ActivityIndicator?) {
        popularPaginator.setRequest { [weak self] page, items, _ in
            guard let this = self else { return emitFail() }

            return this.view(
                page: page,
                indicator: activity(),
                sortOption: this.sortOption.value,
                if: items.isEmpty
            )
        }

        searchPaginator.setRequest { [weak self] page, items, text in
            guard let this = self, let text = text else { return emitFail() }

            return this.search(
                page: page,
                text: text,
                indicator: this.activityIndicator,
                if: items.isEmpty
            )
        }
    }

    private func view(page: Int,
                      indicator: ActivityIndicator?,
                      sortOption: MovieSortingOption,
                      if track: Bool = true)
    -> AnyPublisher<PageState<Movie>, any Error> {
        // Note: Reuse
        return PopularMoviesUseCase(page: page, sortOption: sortOption.key).execute()
            .trackActivity(indicator, if: track)
            .apply(transform: ErrorTransformerHandler(view: view))
            .map(PageState.init)
            .asPublisher()
    }

    private func search(page: Int,
                        text: String,
                        indicator: ActivityIndicator?,
                        if track: Bool = true)
    -> AnyPublisher<PageState<Movie>, any Error> {
        // Note: Reuse
        return SearchMovieUseCase(page: page, input: text).execute()
            .trackActivity(indicator, if: track)
            .apply(transform: ErrorTransformerHandler(view: view))
            .map(PageState.init)
            .asPublisher()
    }

    private func updateData() {
        popularPaginator.reset()
        popularPaginator.loadNextPage()
    }

    private func updateSearchData(_ text: String? = nil) {
        searchPaginator.reset()
        searchPaginator.loadNextPage(text)
    }

    private func bindingActivityIndicator(_ indicator: ActivityIndicator,
                                          to value: AnySubscriber<Bool, Never>) {
        indicator.loading.bind(to: value).store(in: &storage)
    }

    private func bindingDataPublisher<Context>(_ paginator: PaginationRepository<Movie, Context>,
                                               mode: ViewMode) {
        let dataPublisher = paginator.dataPublisher
            .withLatestFrom(viewMode) { ($0, $1) }
            .filter { !$0.isEmpty && $1 == mode }
            .map { $0.0 }

        dataPublisher
            .weakAssign(to: \.data, on: self)
            .store(in: &storage)

        dataPublisher
            .map { !$0.isEmpty }
            .bind(to: view.reloadContent)
            .store(in: &storage)

        paginator.isLoadingPublisher
            .combineLatest(paginator.dataPublisher)
            .map { $0 && !$1.isEmpty }
            .bind(to: view.loadingFooterTrigger)
            .store(in: &storage)
    }
}

extension PopularViewModel: IPopularViewModel {
    var items: Int { data.count }

    var sortingOption: MovieSortingOption { sortOption.value }

    func model(for indexPath: IndexPath) -> Movie {
        return data[indexPath]
    }
}

extension PopularViewModel: Actionable {
    var action: AnyPublisher<PopularNavigationAction, Never> {
        _action.asPublisher()
    }
}

fileprivate extension String {
    var viewMode: ViewMode {
        return isEmpty ? .view : .search
    }
}
