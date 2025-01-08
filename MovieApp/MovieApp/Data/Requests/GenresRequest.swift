//
//  GenresRequest.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct GenresRequest: RequestRepresentable {
    func build() throws -> RequestData {
        return try using(api: .genres, method: .GET, query: .defaultQuery)
    }
}
