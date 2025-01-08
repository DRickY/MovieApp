//
//  SearchMovieRequest.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct SearchMovieRequest: RequestRepresentable {
    var query: Query? {
        BaseQuery(params: [
            "query": input,
            "page": "\(page)"
        ])
    }

    let input: String

    let page: Int

    init(input: String, page: Int = 1) {
        self.input = input
        self.page = page
    }

    func build() throws -> RequestData {
        return try using(api: .searchMovie, method: .GET, query: .defaultQuery)
    }
}
