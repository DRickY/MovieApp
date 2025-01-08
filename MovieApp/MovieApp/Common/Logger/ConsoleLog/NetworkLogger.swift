//
//  NetworkLogger.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct NetworkLogger {
    public enum LogLevel {
        case info
        case all
        case error
        case none
    }

    public enum LogOption {
        case debug
        case jsonPrettyPrint

        public static var defaultOptions: [LogOption] {
            return [.debug, .jsonPrettyPrint]
        }
    }

    let level: LogLevel

    let options: [LogOption]

    public init(level: LogLevel = .all, options: [LogOption] = [.jsonPrettyPrint]) {
        self.level = level
        self.options = options
    }

    private var isPretty: Bool {
        options.contains(.jsonPrettyPrint)
    }

    public func logRequest(request: URLRequest, context: LoggerStackTrace = .trace()) {
        let method = request.httpMethod ?? ""
        let url = request.url?.absoluteString ?? ""
        let headers = prettyPrinted(from: request.allHTTPHeaderFields) ?? ""
        var printed = "[Request] \(method) '\(url)'"

        switch level {
        case .info:
            log.debug(Network, printed, context)

        case .all:
            let body = string(from: request.httpBody, pretty: isPretty) ?? ""
            let printedBody = body.isEmpty ? "" : "\n\n[Body]\n\(body)"
            printed = "\(printed):\n\n[Headers]\n\(headers)\(printedBody)"

            log.debug(Network, printed, context)
        default:
            break
        }
    }

    func logResponse(request: URLRequest?,
                     response: ResponseLoggingInfo,
                     context: LoggerStackTrace = .trace()) {

        guard request != nil, response.httpResponse != nil, level != .none else { return }

        let duration = response.duration
        let data = response.data
        let httpResponse = response.httpResponse
        let error = response.error

        let requestUrl = request?.url?.absoluteString ?? ""
        let requestMethod = request?.httpMethod ?? ""

        let responseData = string(from: data, pretty: isPretty) ?? ""
        let responseHeaders = prettyPrinted(from: httpResponse?.allHeaderFields) ?? ""
        let responseStatusCode = httpResponse?.statusCode ?? 0

        let durationString = String(format: "[%.4f s]", duration)

        let isSuccess = error == nil
        let responseTitle = isSuccess ? "Response" : "Response Error"
        let printed = "[\(responseTitle)] \(responseStatusCode) '\(requestUrl)' \(durationString)"

        switch level {
        case .info:
            log.debug(Network, printed, context)

        case .all:
            let str = "\(printed):\n\n[Headers]:\n\(responseHeaders)\n\n[Body]\n\(responseData)"
            log.debug(Network, str, context)

        case .error:
            if let e = error {
                let str = "[\(responseTitle)] \(requestMethod) '\(requestUrl)' \(durationString) s: \(e.localizedDescription)"
                log.error(Network, str, context)
            }
        default:
            break
        }
    }

    func logDecoding(response: NetworkResponse, errorDecoding: Error?, context: LoggerStackTrace = .trace()) {
        let success = errorDecoding == nil
        let decodingTitle = success ? "Decoding Success" : "Decoding Error"
        let requestUrl = response.reequest.url?.absoluteString ?? ""
        var printed = "[\(decodingTitle)] '\(requestUrl)'"

        if success {
            log.info(Network, printed, context)
        } else {
            if let e = errorDecoding {
                printed = "\(printed) " + e.localizedDescription
            }

            log.error(Network, string, context)
        }
    }

    private func string(from data: Data?, pretty: Bool) -> String? {
        guard let data = data else {  return nil }

        var response: String?

        if pretty,
           let json = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyString = prettyPrinted(from: json) {
            response = prettyString
        } else if let dataString = String(data: data, encoding: .utf8) {
            response = dataString
        }

        return response
    }

    private func prettyPrinted(from json: Any?) -> String? {
        guard let json = json else { return nil }

        var result: String?

        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let string = String(data: data, encoding: .utf8) {
            result = string
        }

        return result
    }
}
