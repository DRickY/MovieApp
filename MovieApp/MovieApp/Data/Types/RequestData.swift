//
//  RequestData.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

struct RequestData {
    let route: String
    let httpMethod: HTTPMethod
    let body: Data?
    let headers: Headers

    init(route: String, httpMethod: HTTPMethod, body: Data? = nil, headers: Headers = .empty) {
        self.route = route
        self.httpMethod = httpMethod
        self.body = body
        self.headers = headers
    }
}
