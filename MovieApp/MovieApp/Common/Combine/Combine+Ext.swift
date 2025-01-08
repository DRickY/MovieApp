//
//  Combine+Ext.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Combine
import Foundation

public typealias DisposeStorage = Set<AnyCancellable>

extension Set where Element == AnyCancellable {
    public func cancel() {
        self.forEach {
            $0.cancel()
        }
    }

    public mutating func clear() {
        self = Set()
    }
}

public extension Publisher {
    func asPublisher() -> AnyPublisher<Self.Output, Self.Failure> {
        self.eraseToAnyPublisher()
    }
}
