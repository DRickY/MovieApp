//
//  Transformer.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

public protocol Transformer {
    associatedtype From
    associatedtype To

    func transform(from: AnyPublisher<From, Swift.Error>) -> AnyPublisher<To, Error>
}

extension Publisher {
    public func apply<T: Transformer>(transform: T) -> AnyPublisher<T.To, Error>
    where T.From == Output, Failure == Error {
        transform.transform(from: self.eraseToAnyPublisher())
    }
}
