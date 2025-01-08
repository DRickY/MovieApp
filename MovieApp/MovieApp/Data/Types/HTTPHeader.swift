//
//  HTTPHeader.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

enum Authorization: CustomStringConvertible {
    case basic(login: String, password: String)
    case bearer(_ token: String)
    case jwt(_ token: String)

    var description: String {
        switch self {
        case let .basic(login, password):
            let pair = "\(login):\(password)"
            guard let token = pair.data(using: .utf8)?.base64EncodedString() else { return "" }

            return "Basic \(token)"
        case let .bearer(token):
            return "Bearer \(token)"
        case let .jwt(token):
            return "JWT \(token)"
        }
    }
}

enum HeaderKey: Equatable, Hashable {
    case contentType
    case authorization
    case custom(String)

    public var key: String { return _key.lowercased() }

    private var _key: String {
        switch self {
        case .contentType:
            return "Content-Type"
        case .authorization:
            return "Authorization"
        case .custom(let value):
            return value
        }
    }
}

struct Header: Hashable {
    let key: HeaderKey
    let value: String

    init(key: HeaderKey, value: CustomStringConvertible) {
        self.key = key
        self.value = value.description
    }
}

extension Header {
    static var json: Header {
        Header(key: .contentType, value: "application/json")
    }

    static func authorization(_ auth: Authorization) -> Self {
        Header(key: .authorization, value: auth)
    }
}

struct Headers: Hashable {
    let values: [Header]

    init(values: [Header]) {
        self.values = values
    }

    init(_ headers: [AnyHashable: Any]) {
        self.values = headers.compactMap {
            guard let key = $0.key as? String,
                  let value = $0.value as? String
            else { return nil }

            return Header(key: .custom(key.lowercased()), value: value)
        }
    }

    static var defaultHeaders: Headers {
        return []
    }
}

extension Headers: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Header...) {
        self.values = elements
    }
}

extension Headers {
    static var empty: Headers {
        return .init(values: [])
    }
}

extension Headers {
    static func + (lhs: Headers, rhs: Headers) -> Headers {
        return Headers(values: lhs.values + rhs.values)
    }
}

extension Headers: Sequence {
    func makeIterator() -> Array<Header>.Iterator {
        return values.makeIterator()
    }
}
