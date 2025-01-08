//
//  Publisher+Emit.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

public func emitOnce<T, F: Swift.Error>(_ value: T) -> AnyPublisher<T, F> {
    Just(value)
        .setFailureType(to: F.self)
        .eraseToAnyPublisher()
}

public func emitEmpty<T, F: Swift.Error>() -> AnyPublisher<T, F> {
    Empty<T, F>(completeImmediately: true)
        .eraseToAnyPublisher()
}

public func emitFail<T, F: Swift.Error>(_ error: F) -> AnyPublisher<T, F> {
    return Fail(error: error).setOutputType(to: T.self).eraseToAnyPublisher()
}

public func emitFail<T>() -> AnyPublisher<T, Error> {
    return Fail(error: AppError.unexpectedError).setOutputType(to: T.self).eraseToAnyPublisher()
}
