//
//  MovieDetailCoordinator.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit
import CombineExt

private let tag = LogTag("MovieDetailCoordinator")

final class MovieDetailCoordinator: Coordinator {
    @Inject()
    private var monitor: IConnectionMonitor

    @Inject()
    private var appConfig: IAppConfig

    private weak var presenter: UIViewController?

    private var navigation: UINavigationController? {
        presenter as? UINavigationController
    }

    private let model: Movie

    private var storage = DisposeStorage()

    var signal: (() -> Void)?

    init(presenter: UIViewController?, model: Movie) {
        self.presenter = presenter
        self.model = model
    }

    func start() {
        let (viewController, viewModel) = FeatureFactory.detailView(movieId: model.movieId)

        viewModel.action.withLatestFrom(monitor.onConnectionStatus) { ($0, $1) }
            .sink { [weak self] navigation, connect in
                switch navigation {
                case .back:
                    self?.navigation?.popViewController(animated: true)
                    self?.signal?()
                case .openPhoto(let movie):
                    self?.showPhoto(movie)
                case .openTrailer(let video):
                    self?.showTrailer(video: video, isOffline: !connect.isReachable)
                }
            }
            .store(in: &storage)

        if let nav = navigation {
            nav.pushViewController(viewController, animated: true)
        } else {
            presenter?.presenting(viewController, animated: true)
        }
    }

    private func showPhoto(_ movie: MovieContent) {
        log.info(tag, "Open Full Photo Screen")

        guard let url = movie.backdrop ?? movie.poster else {
            let alert = FeatureFactory.alert(title: L10n.photoUnavailable,
                                             message: L10n.photoUnavailableInfo,
                                             actionTitle: L10n.Ok)
            presenter?.present(alert, animated: true)
            return
        }

        let (vc, viewModel) = FeatureFactory.photoView(url)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve

        viewModel.action
            .sink { [weak vc] in
                switch $0 {
                case .dismiss:
                    log.info(tag, "Close Full Photo Screen")
                    vc?.dismiss(animated: true, completion: nil)
                }
            }
            .store(in: &storage)

        presenter?.present(vc, animated: true)
    }

    private func showTrailer(video: VideoContent, isOffline: Bool) {
        if isOffline {
            let vc = FeatureFactory.offlineAlert
            presenter?.present(vc, animated: true)
        } else {
            guard let providerURL = appConfig.videoProvider(type: video.site.config)
                    .map({ $0.appending(video.key) })
                    .flatMap(URL.init(string:)) else { return }

            let vc = FeatureFactory.openSafari(url: providerURL)

            log.info(tag, "Show Trailer Screen")

            presenter?.present(vc, animated: true)
        }
    }
}

fileprivate extension VideoProvider {
    var config: ConfigVideoProvider {
        switch self {
        case .youtube:
            return .youtube
        case .custom(let string):
            return .custom(string)
        }
    }
}
