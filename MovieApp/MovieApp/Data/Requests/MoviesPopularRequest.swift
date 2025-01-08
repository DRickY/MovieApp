//
//  MoviesPopularRequest.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct MoviesPopularRequest: RequestRepresentable {
    var query: Query? {
        BaseQuery(params: [
            "page": "\(page)",
            "sort_by": self.sortOption
        ])
    }

    let page: Int
    let sortOption: String

    init(page: Int = 1, sortOption: String) {
        self.page = page
        self.sortOption = sortOption
    }

    func build() throws -> RequestData {
        return try using(api: .popular, method: .GET, query: .defaultQuery)
    }
}
