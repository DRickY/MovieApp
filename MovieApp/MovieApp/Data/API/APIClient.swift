//
//  APIClient.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

protocol IAPIClient {
    func execute(request: RequestRepresentable) -> AnyPublisher<Void, Error>

    func execute<M: Mapper>(request: RequestRepresentable, mapper: M) -> AnyPublisher<M.To, Error> where M.From: Decodable

    func execute<M: Mapper>(request: RequestRepresentable, mapper: M) -> AnyPublisher<[M.To], Error> where M.From: Decodable
}

final class APIClient: IAPIClient {
    @Inject()
    private var client: ClientExecutor

    func execute(request: RequestRepresentable) -> AnyPublisher<Void, Error> {
        do {
            return executeRequest(request: try request.build()).toVoid()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func execute<M: Mapper>(request: RequestRepresentable, mapper: M) -> AnyPublisher<M.To, Error> where M.From: Decodable {
        do {
            return executeRequest(request: try request.build())
                .apply(transform: ObjectDecoder(mapper))
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func execute<M: Mapper>(request: RequestRepresentable, mapper: M) -> AnyPublisher<[M.To], Error> where M.From: Decodable {
        do {
            return executeRequest(request: try request.build())
                .apply(transform: ArrayDecoder(mapper))
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    private func executeRequest(request: RequestData) -> AnyPublisher<NetworkResponse, Error> {
        return client
            .execute(request: request)
            .apply(transform: StatusCodeMapper())
            .apply(transform: ErrorMapper())
    }
}
