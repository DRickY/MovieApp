//
//  Query.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

protocol Query {
    func build() throws -> String
}

struct BaseQuery: Query {
    let params: [String: String]

    func build() throws -> String {
        let pairs = params.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }

        return pairs.joined(separator: "&")
    }
}

struct ComposeQuery: Query {
    private let queries: [Query?]

    init(_ queries: [Query?]) {
        self.queries = queries
    }

    func build() throws -> String {
        let compacted = queries.compactMap { $0 }

        let pairs = try compacted.compactMap {
            try $0.build().isEmpty ? nil : try $0.build()
        }

        return pairs.joined(separator: "&")
    }

    var isEmpty: Bool {
        return queries.compactMap { $0 }.isEmpty
    }
}
