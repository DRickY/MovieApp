//
//  InjectWrapper.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

@propertyWrapper
public struct Inject<T> {

    private let key: T.Type

    private let container: DependencyContainer

    public var wrappedValue: T {
        guard let dependency: T = container.resolve(for: key) else {
            fatalError("Dependency of type \(T.self) not registered for key \(key)")
        }

        return dependency
    }

    public init(_ key: T.Type = T.self, container: DependencyContainer = .shared) {
        self.key = key
        self.container = container
    }
}
