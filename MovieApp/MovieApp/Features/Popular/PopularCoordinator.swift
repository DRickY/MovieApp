//
//  PopularCoordinator.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit
import CombineExt

private let tag = LogTag("PopularCoordinator")

final class PopularCoordinator: Coordinator {
    @Inject()
    private var monitor: IConnectionMonitor

    private weak var presenter: UIViewController?

    private var storage = DisposeStorage()

    private var detailCoordinator: Coordinator?

    init(presenter: UIViewController?) {
        self.presenter = presenter
    }

    func start() {
        let (popularViewController, popularViewModel) = FeatureFactory.popularView

        popularViewModel.action.withLatestFrom(monitor.onConnectionStatus) { ($0, $1) }
            .sink { [weak self] navigation, connect in
                guard connect.isReachable else {
                    self?.showAlert()
                    return
                }

                switch navigation {
                case .open:
                    break
                //                    self?.openDetail(model)
                }
            }
            .store(in: &storage)

        let navigationController = UINavigationController()

        navigationController.viewControllers = [popularViewController]
        presenter?.presenting(navigationController, animated: false)
    }

    private func showAlert() {
        let vc = FeatureFactory.offlineAlert

        presenter?.presentedViewController?.present(vc, animated: true)
    }
}
