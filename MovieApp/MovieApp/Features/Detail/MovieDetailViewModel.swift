//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

protocol IMovieDetailViewModel {

}

enum MovieDetailNavigatorAction {
    case back
    case openPhoto(MovieContent)
    case openTrailer(VideoContent)
}

final class MovieDetailViewModel {
    @Inject()
    private var monitor: IConnectionMonitor

    private var storage = DisposeStorage()

    private let _action = PassthroughSubject<MovieDetailNavigatorAction, Never>()

    private let movieContent = SingleValueSubject<MovieContent, Never>()

    private let activityIndicator = ActivityIndicator()

    private unowned let view: MovieDetailView

    init(view: MovieDetailView, movieId: Int) {
        self.view = view

        activityIndicator.loading
            .bind(to: view.isLoading)
            .store(in: &storage)

        let isReachable = monitor.onConnectionStatus.map { $0.isReachable }

        isReachable
            .bind(to: view.disable)
            .store(in: &storage)

        view.loadTrigger.mapTo(movieId)
            .flatMap { [weak self] id -> AnyPublisher<MovieContent, Error> in
                guard let this = self else {
                    let e = NSError(domain: "Ownership Error", code: -1)
                    return emitFail(e)
                }

                return ContentMovieUseCase(movieId: id).execute()
                    .trackActivity(this.activityIndicator)
                    .apply(transform: ErrorTransformerHandler(view: this.view))
                    .eraseToAnyPublisher()
            }
            .ignoreFailure(setFailureType: Never.self)
            .weakAssign(to: \.movieContent, on: self)
            .store(in: &storage)

        movieContent
            .bind(to: view.content)
            .store(in: &storage)

        view.backTapTrigger
            .mapTo(MovieDetailNavigatorAction.back)
            .weakAssign(to: \._action, on: self)
            .store(in: &storage)

        view.posterImageTapTrigger
            .withLatestFrom(movieContent) {
                MovieDetailNavigatorAction.openPhoto($1)
            }
            .weakAssign(to: \._action, on: self)
            .store(in: &storage)

        view.trailerTapTrigger
            .withLatestFrom(movieContent) { $1.videoContent }
            .compactMap { $0 }
            .map { MovieDetailNavigatorAction.openTrailer($0) }
            .weakAssign(to: \._action, on: self)
            .store(in: &storage)
    }
}

extension MovieDetailViewModel: Actionable {
    var action: AnyPublisher<MovieDetailNavigatorAction, Never> {
        return _action.asPublisher()
    }
}

extension MovieDetailViewModel: IMovieDetailViewModel { }
