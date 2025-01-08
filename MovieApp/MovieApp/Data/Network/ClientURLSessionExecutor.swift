//
//  ClientURLSessionExecutor.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine
import SwiftUI

let Network = LogTag("Network")

protocol ClientExecutor {
    func execute(request: RequestData) -> AnyPublisher<NetworkResponse, Error>
}

struct ClientURLSessionExecutor: ClientExecutor {
    struct Response {
        let request: URLRequest
        let response: HTTPURLResponse?
        let data: Data?
        let error: Error?
        let duration: TimeInterval

        var result: Swift.Result<Data, Swift.Error> {
            if let data = data {
                return .success(data)
            } else {
                // swiftlint:disable:next force_unwrapping
                return .failure(error!)
            }
        }
    }

    @Inject()
    private var session: URLSessionHolder

    private var logger = NetworkLogger(level: .info)

    func execute(request: RequestData) -> AnyPublisher<NetworkResponse, Error> {
        guard let urlRequest = self.request(from: request) else {
            return Fail(error: HTTPError.invalidRequest).eraseToAnyPublisher()
        }

        let request = session.session.dataTaskPublisher(for: urlRequest)

        logger.logRequest(request: urlRequest, context: .trace())

        let start = DispatchTime.now()

        let result = request
            .map { data, response in
                return Response(request: urlRequest,
                                response: response as? HTTPURLResponse,
                                data: data,
                                error: nil,
                                duration: start.profile())
            }
            .catch {
                return Just(Response(request: urlRequest,
                                     response: nil,
                                     data: nil,
                                     error: $0,
                                     duration: start.profile()))
            }
            .handleEvents(receiveOutput: {
                let loggingInfo = ResponseLoggingInfo(
                    httpResponse: $0.response,
                    data: $0.data,
                    error: $0.error,
                    duration: $0.duration)

                self.logger.logResponse(request: $0.request,
                                        response: loggingInfo, context: .trace())
            })
            .tryMap { [urlRequest] in
                switch $0.result {
                case .success(let data):
                    return NetworkResponse(
                        reequest: urlRequest,
                        httpResponse: $0.response,
                        data: data,
                        duration: $0.duration)
                case .failure(let error):
                    throw error as Swift.Error
                }
            }

        return result.asPublisher()
    }

    private func request(from request: RequestData) -> URLRequest? {
        let route = request.route

        guard var urlReq = route.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                .flatMap(URL.init(string: ))
                .flatMap({ URLRequest(url: $0) }) else { return nil }

        urlReq.httpMethod = request.httpMethod.rawValue
        urlReq.httpBody = request.body

        let headers = distinctHeaders(Headers.defaultHeaders + request.headers)

        for header in headers {
            urlReq.addValue(header.value, forHTTPHeaderField: header.key.key)
        }

        return urlReq
    }

    private func distinctHeaders(_ headers: Headers) -> [Header] {
        let groups = Dictionary.init(grouping: headers) { $0.key }

        return groups.compactMap({ $0.value.last })
    }
}
