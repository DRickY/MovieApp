//
//  PaginationRepository.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit
import Combine

struct PageState<T> {
    let items: [T]
    let page: Int
    let totalPages: Int
    let totalResults: Int
}

extension PageState {
    init(page: Page<T>) {
        self.items = page.content
        self.page = page.page
        self.totalPages = page.totalPages
        self.totalResults = page.totalResults
    }
}

final class PaginationRepository<T, Context> {
    private let _loadStream = PassthroughSubject<Context, Never>()

    private var cancelable: AnyCancellable?

    private var _loading = PassthroughSubject<Bool, Never>()

    private var _data = PassthroughSubject<[T], Never>()

    private var _error = PassthroughSubject<Error?, Never>()

    private var totalPages: Int

    private var totalItems: Int

    private var page: Int

    private var nextPage: Int {
        page + 1
    }

    private var hasMorePages: Bool {
        if page == 0, totalPages == 0 { return true }
        return page <= totalPages
    }

    private var hasPendingLoad = false

    private var context: Context?

    private var requestPublisher: ((Int, [T], Context) -> AnyPublisher<PageState<T>, Error>)?

    public private(set) var error: Error? {
        didSet { _error.send(error) }
    }

    public private(set) var isLoading: Bool {
        didSet { _loading.send(isLoading) }
    }

    public private(set) var items: [T] {
        didSet { publish() }
    }

    init() {
        items = []
        page = 0
        totalPages = 0
        totalItems = 0
        isLoading = false
        setupBindings()
    }

    private func setupBindings() {
        let stream = _loadStream
            .filter { [weak self] _ in
                guard let this = self else { return false }
                guard !this.isLoading else {
                    return false
                }

                if this.requestPublisher == nil {
                    this.hasPendingLoad = true
                    return false
                }

                return this.hasMorePages
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.error = nil
            })
            .flatMap { [weak self] context -> AnyPublisher<PageState<T>, Error> in
                guard let this = self, let publisher = this.requestPublisher else {
                    let e = NSError(domain: "Ownership Error", code: -1)

                    return emitFail(e)
                }

                return publisher(this.nextPage, this.items, context)
            }

        cancelable = stream
            .sink { [weak self] completion in
                guard let this = self else { return }
                this.isLoading = false

                if case .failure(let error) = completion {
                    this.error = error
                }
            } receiveValue: { [weak self] pageState in
                guard let this = self else { return }

                this.items.append(contentsOf: pageState.items)
                this.totalPages = pageState.totalPages
                this.totalItems = pageState.totalResults
                this.page = pageState.page
                this.isLoading = false
            }
    }

    public func setRequest(publisher: @escaping (Int, [T], Context)
                            -> AnyPublisher<PageState<T>, Error>) {
        self.requestPublisher = publisher

        if hasPendingLoad, requestPublisher != nil {
            hasPendingLoad = false
            if let context = self.self.context.take() {
                loadNextPage(context)
            }
        }
    }

    public func publish() {
        _data.send(items)
    }

    public func loadNextPage(_ context: Context) {
        self.context = context
        _loadStream.send(context)
    }

    public func loadNextPage()
    where Context == Void {
        self.context = ()
        _loadStream.send(())
    }

    public func reset() {
        cancelLoading()
        items = []
        page = 0
        totalPages = 0
        totalItems = 0
        isLoading = false
        error = nil
        context = nil

        setupBindings()
    }

    public func cancelLoading() {
        cancelable?.cancel()
        cancelable = nil
        isLoading = false
    }
}

extension PaginationRepository {
    var dataPublisher: AnyPublisher<[T], Never> {
        _data.asPublisher()
    }

    var errorPublisher: AnyPublisher<Error?, Never> {
        _error.compactMap { $0 }.asPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        _loading.asPublisher()
    }
}
