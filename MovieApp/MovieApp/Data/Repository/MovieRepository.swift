//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

protocol IMovieRepository {
    func popularMovies(page: Int, sortOption: String) -> AnyPublisher<Page<Movie>, Error>

    func searchMovie(input: String, page: Int) -> AnyPublisher<Page<Movie>, Error>
}

struct MovieRepository: IMovieRepository {
    @Inject()
    var api: IAPIClient

    func popularMovies(page: Int, sortOption: String) -> AnyPublisher<Page<Movie>, Error> {
        return api.execute(
            request: MoviesPopularRequest(page: page, sortOption: sortOption),
            mapper: PopularMapper()
        )
    }

    func searchMovie(input: String, page: Int) -> AnyPublisher<Page<Movie>, Error> {
        return api.execute(
            request: SearchMovieRequest(input: input, page: page),
            mapper: PopularMapper()
        )
    }
}
