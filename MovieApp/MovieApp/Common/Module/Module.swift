//
//  Module.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

@MainActor
public protocol Module {
    /// Called before the application starts.
    /// Use this method to declare the module's dependencies in the provided dependency container.
    /// - Parameter ioc: The `DependencyContainer` instance used to register dependencies.
    func registerModule(using ioc: DependencyContainer)

    /// Called after all modules' `registerModule(using:)` methods have been invoked.
    /// Use this method to set up entities that depend on other modules.
    /// Note: At this stage, no processes should be started. Use the `finalizeModule(using:)` method for initialization.
    /// - Parameter ioc: The `Resolver` instance used to resolve dependencies.
    func prepareModule(using ioc: DependencyContainer)

    /// Called after the container is fully built and all services have been initialized.
    /// Use this method to start the module's operations or services.
    /// - Parameter ioc: The `Resolver` instance for resolving dependencies.
    func finalizeModule(using ioc: DependencyContainer)
}

extension Array where Element == Module {
    @MainActor func registerModule(using ioc: DependencyContainer) {
        for module in self {
            module.registerModule(using: ioc)
        }

        forEach { $0.prepareModule(using: ioc) }
        forEach { $0.finalizeModule(using: ioc) }
    }
}
