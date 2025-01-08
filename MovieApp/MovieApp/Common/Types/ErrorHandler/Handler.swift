//
//  Handler.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct Handler: ErrorHandler {

    let handlers: [ErrorHandler]

    init(_ handlers: ErrorHandler...) {
        self.handlers = handlers
    }

    init(handlers: [ErrorHandler]) {
        self.handlers = handlers
    }

    @discardableResult
    func handle(error: AppError) -> Bool {
        let handler = handlers.first(where: { $0.handle(error: error) })
        return handler != nil
    }
}
