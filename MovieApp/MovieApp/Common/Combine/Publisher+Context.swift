//
//  Publisher+Context.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

extension Publisher {
    public func map<Context: AnyObject, R>(
        _ context: Context,
        _ callback: @escaping (Context, Output) -> R
    ) -> AnyPublisher<R, Failure> {
        return flatMap { [weak context] next in
            guard let this = context else {
                return Empty<R, Failure>(completeImmediately: true).eraseToAnyPublisher()
            }

            return emitOnce(callback(this, next))
        }
        .eraseToAnyPublisher()
    }

    public func filter<Context: AnyObject>(
        _ context: Context,
        isIncluded: @escaping (Context, Self.Output) -> Bool) -> Publishers.Filter<Self> {
        return filter({ [weak context] in
            guard let this = context else { return false }

            return isIncluded(this, $0)
        })
    }
}
