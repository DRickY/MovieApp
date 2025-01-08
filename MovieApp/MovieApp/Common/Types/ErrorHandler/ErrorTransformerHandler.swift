//
//  ErrorTransformerHandler.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

public struct ErrorTransformerHandler<T>: Transformer {
    let view: ErrorShowing

    public init(view: ErrorShowing) {
        self.view = view
    }

    public func transform(from: AnyPublisher<T, Error>) -> AnyPublisher<T, Swift.Error> {
        return from
            .receive(on: DispatchQueue.main)
            .catch({ [weak view] error in
                if let appError = error as? AppError {
                    view?.showError(error: appError)
                } else {
                    view?.showError(error: AppError.unexpectedError)
                }

                return Empty<T, Swift.Error>(completeImmediately: true).asPublisher()
            })
            .asPublisher()
    }
}
