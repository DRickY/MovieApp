//
//  Resolver.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public func resolve<T>(_ key: T.Type = T.self) -> T {
    return DependencyContainer.shared.resolve(for: T.self)
}
