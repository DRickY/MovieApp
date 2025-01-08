//
//  StatusCodeMapper.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

struct StatusCodeValidator {
    func validate(data: Data, response: HTTPURLResponse?) throws {
        guard let statusCode = response?.statusCode else { return }

        switch statusCode {
        case 100..<300:
            return
        case 400..<500:
            throw HTTPError.httpError(status: statusCode, data: data)
        case 500..<600:
            throw HTTPError.serverError(status: statusCode, data: data)
        default:
            throw AppError.unexpectedError
        }
    }
}

struct StatusCodeMapper: Transformer {
    private let validator: StatusCodeValidator

    init(validator: StatusCodeValidator = .init()) {
        self.validator = validator
    }

    func transform(from: AnyPublisher<NetworkResponse, any Error>) -> AnyPublisher<NetworkResponse, any Error> {
        from.tryMap {
            try validator.validate(data: $0.data, response: $0.httpResponse)

            return $0
        }
        .asPublisher()
    }
}
