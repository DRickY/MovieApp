//
//  Modularity.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public final class DependencyContainer {

    public static let shared = DependencyContainer()

    private let lock = NSRecursiveLock()

    private var storage: [AnyHashable: Any] = [:]

    private var factories: [AnyHashable: (DependencyContainer) -> Any] = [:]

    private var lifetimePolicies: [AnyHashable: LifetimePolicy] = [:]

    public enum LifetimePolicy {
        case singleton
        case transient
    }

    public func register<T>(for type: T.Type,
                            lifetime: LifetimePolicy = .transient,
                            factory: @escaping (DependencyContainer) -> T
    ) {
        lock.lock()
        defer { lock.unlock() }

        let key = AnyHashable.key(for: type)

        lifetimePolicies[key] = lifetime

        if lifetime == .singleton {
            storage[key] = factory(self)
        }

        factories[key] = factory
    }

    public func remove<T>(for type: T.Type) {
        lock.lock()
        defer { lock.unlock() }
        let key = AnyHashable.key(for: type)

        storage.removeValue(forKey: key)
        factories.removeValue(forKey: key)
        lifetimePolicies.removeValue(forKey: key)
    }

    public func resolve<T>(for type: T.Type) -> T? {
        lock.lock()
        defer { lock.unlock() }

        let key = AnyHashable.key(for: type)

        guard let policy = lifetimePolicies[key] else {
            return nil
        }

        switch policy {
        case .singleton:
            if let stored = storage[key] as? T {
                return stored
            }

            if let factory = factories[key] {
                let dependency = factory(self) as? T
                if let dependency = dependency {
                    storage[key] = dependency
                }
                return dependency
            }

            return nil

        case .transient:
            if let factory = factories[key], let module = factory(self) as? T {
                return module
            }
            return nil
        }
    }

    public func clear() {
        lock.lock()
        defer { lock.unlock() }

        storage.removeAll()
        factories.removeAll()
        lifetimePolicies.removeAll()
    }
}

extension DependencyContainer {
    public func resolve<T>(for key: T.Type) -> T {
        guard let dependency: T = resolve(for: key) else {
            fatalError("Dependency of type \(T.self) not registered for key \(key)")
        }
        return dependency
    }
}
