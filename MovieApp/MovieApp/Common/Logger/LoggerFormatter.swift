//
//  LoggerFormat.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public protocol LoggerFormatter {
    var pattern: String { get }
    
    func format(_ message: Any, _ stack: LoggerStackTrace) -> Any
}
