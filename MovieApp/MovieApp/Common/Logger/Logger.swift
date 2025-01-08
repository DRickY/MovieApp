//
//  Logger.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public protocol BaseLogger: AnyObject {
    func log(_ message: Lazy<Any>, level: LoggerLevel, tag: LogTag, _ stack: LoggerStackTrace)
}

public extension BaseLogger {
    fileprivate func log(_ message: @escaping @autoclosure () -> Any, level: LoggerLevel, tag: LogTag, stack: LoggerStackTrace) {
        log(Lazy(message), level: level, tag: tag, stack)
    }

    func verbose(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, file: String = #file, method: String = #function, line: UInt = #line, column: UInt = #column) {
        log(message, level: .verbose, tag: tag, stack: .trace(file: file, method: method, line: line, column: column))
    }

    func debug(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, file: String = #file, method: String = #function, line: UInt = #line, column: UInt = #column) {
        log(message, level: .debug, tag: tag, stack: .trace(file: file, method: method, line: line, column: column))
    }

    func info(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, file: String = #file, method: String = #function, line: UInt = #line, column: UInt = #column) {
        log(message, level: .info, tag: tag, stack: .trace(file: file, method: method, line: line, column: column))
    }

    func warning(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, file: String = #file, method: String = #function, line: UInt = #line, column: UInt = #column) {
        log(message, level: .warning, tag: tag, stack: .trace(file: file, method: method, line: line, column: column))
    }

    func error(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, file: String = #file, method: String = #function, line: UInt = #line, column: UInt = #column) {
        log(message, level: .error, tag: tag, stack: .trace(file: file, method: method, line: line, column: column))
    }

    func verbose(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, _ stack: LoggerStackTrace) {
        log(message, level: .verbose, tag: tag, stack: stack)
    }

    func debug(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, _ stack: LoggerStackTrace) {
        log(message, level: .debug, tag: tag, stack: stack)
    }

    func info(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, _ stack: LoggerStackTrace) {
        log(message, level: .info, tag: tag, stack: stack)
    }

    func warning(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, _ stack: LoggerStackTrace) {
        log(message, level: .warning, tag: tag, stack: stack)
    }

    func error(_ tag: LogTag = .tag(), _ message: @autoclosure @escaping () -> Any, _ stack: LoggerStackTrace) {
        log(message, level: .error, tag: tag, stack: stack)
    }
}

public protocol Logger: BaseLogger {
    var minimumLevel: LoggerLevel { get }

    var formatter: LoggerFormatter { get set }

    var excludedTags: [LogTag] { get set }

    var allowedTags: [LogTag] { get set }

    func isLoggingAllowed(level: LoggerLevel, tag: LogTag) -> Bool
}

public extension Logger {
    func isLoggingAllowed(level: LoggerLevel, tag: LogTag) -> Bool {
        if level.rawValue < minimumLevel.rawValue { return false }

        if !allowedTags.isEmpty && !allowedTags.contains(where: { tag == $0 }) { return false }

        if !excludedTags.isEmpty && excludedTags.contains(where: { tag == $0 }) { return false }

        return true
    }
}

public extension Logger {
    var minimumLevel: LoggerLevel { .verbose }

    var excludedTags: [LogTag] {
        return []
    }

    var allowedTags: [LogTag] {
        return []
    }
}
