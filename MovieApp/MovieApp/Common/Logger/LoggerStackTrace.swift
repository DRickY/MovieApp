//
//  LoggerStackTrace.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public struct LogTag: Equatable, ExpressibleByStringLiteral {
    public let logTag: String

    public init(_ tag: String) {
        self.logTag = tag
    }

    public init(stringLiteral value: String) {
        self.logTag = value
    }

    public static func tag(tag: String = "") -> LogTag {
        return LogTag(tag)
    }

    public static func == (lhs: LogTag, rhs: LogTag) -> Bool {
        return lhs.logTag == rhs.logTag
    }
}

public struct LoggerStackTrace {
    public let filename: String
    public let method: String
    public let line: UInt
    public let column: UInt

    public init(filename: String, method: String, line: UInt, column: UInt) {
        self.filename = filename
        self.method = method
        self.line = line
        self.column = column
    }

    public static func trace(file: String = #file, method: String = #function, line: UInt = #line, column: UInt = #column) -> LoggerStackTrace {
        return LoggerStackTrace(filename: file, method: method, line: line, column: column)
    }
}

public class Lazy<T> {
    public private(set) lazy var value: T = callback()
    private let callback: () -> T

    init(_ callback: @escaping () -> T) {
        self.callback = callback
    }
}
