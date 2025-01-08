//
//  GenreDTO.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}

extension GenreDTO: Hashable {}

extension Array where Element == GenreDTO {
    var genresText: String {
        if self.isEmpty {
            return L10n.unknown
        }

        return self.map(\.name).joined(separator: ", ")
    }
}

struct GenresDTO: Decodable {
    let genres: [GenreDTO]
}

struct GenreMapper: Mapper {
    func map(from object: GenresDTO) throws -> [GenreDTO] {
        return object.genres
    }
}
