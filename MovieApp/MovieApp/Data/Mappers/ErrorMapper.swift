//
//  ErrorMapper.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

struct ErrorMapper: Transformer {
    func transform(from: AnyPublisher<NetworkResponse, Error>) -> AnyPublisher<NetworkResponse, Error> {
        return from.catch({ error -> AnyPublisher<NetworkResponse, Error> in
            let string = "[Error] " + error.localizedDescription

            log.error(Network, string)

            if let appError = error as? AppError {
                return Fail(error: appError).asPublisher()
            }
            guard let httpError = error as? HTTPError else {
                return Fail(error: AppError.unexpectedError).asPublisher()
            }

            switch httpError {
            case .networkError(let error):
                log.error(Network, error)
                return Fail(error: AppError.connectionError).asPublisher()
            case .httpError(let status, let content):
                return self.httpError(content, status)
            case .invalidRequest, .noContent, .noResponse:
                return Fail(error: AppError.unexpectedError).asPublisher()
            case .serverError:
                return Fail(error: AppError.serverError).asPublisher()
            }
        })
        .asPublisher()
    }

    private func httpError(_ content: Data, _ status: Int) -> AnyPublisher<NetworkResponse, Error> {
        switch status {
        case 400..<500:
            return Fail(error: AppError.httpError(status)).asPublisher()
        case 500..<600:
            return Fail(error: AppError.serverError).asPublisher()
        default:
            return Fail(error: AppError.unexpectedError).asPublisher()
        }
    }
}
