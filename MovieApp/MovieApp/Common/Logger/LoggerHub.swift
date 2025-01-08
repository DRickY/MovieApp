//
//  LoggerHub.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public class LoggerHub: BaseLogger {

    private var loggers: [Logger] = []

    private let hubQueue = DispatchQueue(label: "LoggerHubQueue", qos: .default)

    public init() {}

    public func log(_ message: Lazy<Any>, level: LoggerLevel, tag: LogTag, _ stack: LoggerStackTrace) {
        hubQueue.async { [weak self] in
            guard let this = self else { return }

            let loggers = this.loggers.filter {
                $0.isLoggingAllowed(level: level, tag: tag)
            }

            loggers.forEach {
                $0.log(message, level: level, tag: tag, stack)
            }
        }
    }

    public func addLoggers(_ loggers: Logger...) {
        loggers.forEach { type in
            if !self.loggers.contains(where: { type === $0 }) {
                self.loggers.append(type)
            }
        }
    }

    public func removeLoggers(_ loggers: Logger...) {
        loggers.forEach { type in
            if let idx = self.loggers.firstIndex(where: { type === $0 }) {
                self.loggers.remove(at: idx)
            }
        }
    }

    public func excludedTags(tag: LogTag) {
        loggers.forEach {
            $0.excludedTags.append(tag)
        }
    }
}
