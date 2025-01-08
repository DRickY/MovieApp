//
//  AppCoordinator.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit

private let tag = LogTag("AppCoordinator")

final class AppCoordinator: Coordinator {
    unowned let window: UIWindow
    private var presenter: UIViewController?

    init(window: UIWindow) {
        self.window = window
    }

    func start(_ completion: (() -> Void)?) {
        let controller = UIViewController()
        window.rootViewController = controller

        window.makeKeyAndVisible()

        self.presenter = controller
    }
}
