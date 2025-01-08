//
//  ErrorHandler.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

protocol ErrorHandler {
    func handle(error: AppError) -> Bool
}
