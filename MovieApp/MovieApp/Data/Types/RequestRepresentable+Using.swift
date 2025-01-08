//
//  RequestRepresentable+Using.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

extension RequestRepresentable {
    func using<T: RouteType>(route: T, method: HTTPMethod, body: Data? = nil, headers: Headers = [], query defaultQuery: Query? = nil) throws -> RequestData {
        let headers = defaultHeaders + headers

        var route = try route.route()

        let composedQuery = ComposeQuery([self.query, defaultQuery])

        if !composedQuery.isEmpty {
            let query = try composedQuery.build()

            route = query.isEmpty ? route : "\(route)?\(query)"
        }

        return RequestData(
            route: route,
            httpMethod: method,
            body: body,
            headers: headers
        )
    }

    func using(api: APIPath, method: HTTPMethod, body: Data? = nil, headers: Headers = [], query: Query? = nil) throws -> RequestData {
        return try using(route: api, method: method, body: body, headers: headers, query: query)
    }
}

extension EncodedRequestRepresentable {
    func using<T: RouteType>(route: T, method: HTTPMethod, headers: Headers = [], query: Query? = nil) throws -> RequestData {
        return try using(route: route,
                         method: method,
                         body: encoder.encode(encodable),
                         headers: headers,
                         query: query)
    }

    func using(api: APIPath, method: HTTPMethod, headers: Headers = [], query: Query? = nil) throws -> RequestData {
        return try using(route: api, method: method, headers: headers, query: query)
    }
}
