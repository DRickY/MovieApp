//
//  ConsoleLogger.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public class ConsoleLogger: Logger {
    public var allowedTags: [LogTag] = []

    public var excludedTags: [LogTag] = []

    public var formatter: LoggerFormatter

    public init(formatter: LoggerFormatter = ConsoleFormatter()) {
        self.formatter = formatter
    }

    public func log(_ lazyMessage: Lazy<Any>, level: LoggerLevel, tag: LogTag, _ context: LoggerStackTrace) {
        if !isLoggingAllowed(level: level, tag: tag) { return }

        let symbolLevel = logLevelSymbol(level)
        let tag = tag.logTag
        let message = formatter.format(lazyMessage.value, context)

        print("\(symbolLevel)[\(tag)] - \(message)\(symbolLevel)")
    }

    func logLevelSymbol(_ level: LoggerLevel) -> String {
        switch level {
        case .verbose:
            return "📜"
        case .debug:
            return "🛠️"
        case .info:
            return "💡"
        case .warning:
            return "🚧"
        case .error:
            return "💥"
        }
    }
}

public struct ConsoleFormatter: LoggerFormatter {
    public let pattern: String

    public init(pattern: String = "") {
        self.pattern = pattern
    }

    public func format(_ message: Any, _ stack: LoggerStackTrace) -> Any {
        var format = self.pattern

        if format.contains("<where>") {
            var path = ""
            let with = !stack.method.isEmpty ? "\(stack.method)" : ""

            if let fileName = (stack.filename as NSString).lastPathComponent.components(separatedBy: ".").first {
                path = "\(fileName).\(with)"
            } else {
                path = "\("\(stack.filename).\(with)")"
            }

            format = format.replacingOccurrences(of: "<where>", with: path)
        }

        if format.contains("<what>") {
            let what = ":\(stack.line)"
            format = format.replacingOccurrences(of: "<what>", with: what)
        }

        if format.contains("<log>") {
            let log = " \(message)"
            format = format.replacingOccurrences(of: "<log>", with: log)
        }

        return format
    }
}
