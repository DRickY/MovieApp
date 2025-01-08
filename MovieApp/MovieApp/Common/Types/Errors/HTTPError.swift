//
//  HTTPError.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public enum HTTPError: Error {
    case invalidRequest
    case networkError(Error)
    case noResponse
    case noContent
    case httpError(status: Int, data: Data)
    case serverError(status: Int, data: Data)
}
