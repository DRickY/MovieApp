//
//  AppError.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

public enum AppError: Error {
    case validationError
    case connectionError
    case httpError(Int)
    case serverError
    case unexpectedError
    case mappingError(Error)
}

extension AppError {
    func handle(_ handlers: ErrorHandler...) {
        Handler(handlers: handlers).handle(error: self)
    }
}
