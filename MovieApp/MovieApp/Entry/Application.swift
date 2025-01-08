//
//  Application.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit

let log = LoggerHub()

@MainActor
final public class Application {
    private var appCoordinator: AppCoordinator?

    private var modules: [Module] {
        return [
            AppModule(),
            PopularModule()
        ]
    }

    func globalAppearances() {
        UINavigationBar.appearance().apply(NavigationTabDecorator())
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        registerModule()

        globalAppearances()

        return true
    }
}

public extension Application {
    func startApp(inWindow window: UIWindow) {
        let coordinator = AppCoordinator(window: window)
        self.appCoordinator = coordinator

        coordinator.start()
    }
}

extension Application {
    func registerModule() {
        modules.registerModule(using: DependencyContainer.shared)
    }

    func cleanModule() {
        DependencyContainer.shared.clear()
    }
}
