//
//  NetworkResponse.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct NetworkResponse {
    let reequest: URLRequest
    let httpResponse: HTTPURLResponse?
    let data: Data
    let duration: TimeInterval

    var headers: Headers {
        return Headers(httpResponse?.allHeaderFields ?? [:])
    }

    var statusCode: Int {
        return httpResponse?.statusCode ?? 0
    }
}
