//
//  RequestRepresentable.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

protocol RequestRepresentable {
    var query: Query? { get }
    var defaultHeaders: Headers { get }

    func build() throws -> RequestData
}

extension RequestRepresentable {
    var query: Query? { nil }

    var defaultHeaders: Headers {
        let config = resolve(IAppConfig.self)

        return [
            .authorization(.bearer(config.apiKey)),
            .json
        ]
    }
}

protocol EncodedRequestRepresentable: RequestRepresentable {
    associatedtype EncodableValue: Encodable
    var encoder: Encoder { get }
    var encodable: EncodableValue { get }
}

extension EncodedRequestRepresentable where Self: Encodable {
    var encodable: Self { self }
}

protocol JSONRequestRepresentable: EncodedRequestRepresentable {}

extension JSONRequestRepresentable {
    var encoder: Encoder { JSONEncoder() }
}
