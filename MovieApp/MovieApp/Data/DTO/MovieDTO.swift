//
//  MovieDTO.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

// Note: These settings are optional because it's unclear which values might be null when the API provides data.
struct MovieDTO: Decodable {
    let id: Int
    let title: String?
    let originalTitle: String?
    let releaseDate: String?
    let voteAverage: Double? // Decimal
    let genreIds: [Int]?
    let backdropPath: String?
    let posterPath: String?
}

struct Paginator<T: Decodable>: Decodable {
    let results: [T] // 20
    let page: Int // 1
    let totalPages: Int // 47838
    let totalResults: Int // 956749
}

struct PopularMapper: Mapper {
    @Inject()
    private var genreService: IGenreService

    func map(from object: Paginator<MovieDTO>) throws -> Page<Movie> {
        let dateMapper = DateMapper()
        let imageMapper = ImageURLMapper(imageSize: .small)
        let calendar = Calendar.current
        let inputGenres = genreService.genres

        let movies = object.results.map { movie in
            let genres = movie.genreIds ?? []

            let mappedGenres = genres.compactMap { idx in
                inputGenres.first(where: { genre in genre.id == idx })
            }

            let date = movie.releaseDate.flatMap {
                try? dateMapper.map(from: $0)
            }

            let year = date.map {
                "\(calendar.component(.year, from: $0))"
            } ?? L10n.unknown

            let posterURL = movie.posterPath.flatMap {
                try? imageMapper.map(from: $0)
            }

            let backdropURL = movie.backdropPath.flatMap {
                try? imageMapper.map(from: $0)
            }

            let average = movie.voteAverage.map { String(format: "%.2f", $0) }  ?? "0.0"

            let title = (movie.title.isEmpty ? movie.originalTitle : movie.title) ?? L10n.unknown

            return Movie(movieId: movie.id,
                         title: title,
                         genre: mappedGenres.genresText,
                         year: year,
                         average: average,
                         poster: posterURL,
                         backdrop: backdropURL)
        }

        return Page(content: movies,
                    page: object.page,
                    totalPages: object.totalPages,
                    totalResults: object.totalResults)
    }
}
