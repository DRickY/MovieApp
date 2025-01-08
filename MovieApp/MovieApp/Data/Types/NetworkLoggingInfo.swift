//
//  NetworkLoggingInfo.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct ResponseLoggingInfo {
    let httpResponse: HTTPURLResponse?
    let data: Data?
    let error: Swift.Error?
    let duration: TimeInterval
}
