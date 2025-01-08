//
//  MovieDetailRequest.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct MovieDetailRequest: RequestRepresentable {
    var query: Query? {
        BaseQuery(params: [
            "append_to_response": "videos"
        ])
    }

    let movieId: Int

    func build() throws -> RequestData {
        return try using(api: .movie(id: movieId), method: .GET, query: .defaultQuery)
    }
}
