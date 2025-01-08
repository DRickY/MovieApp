//
//  PopularMoviesUseCase.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

private let tag = LogTag("PopularMoviesUseCase")

struct PopularMoviesUseCase: UseCase {
    @Inject()
    var repo: IMovieRepository

    let page: Int

    let sortOption: String

    func execute() -> AnyPublisher<Page<Movie>, Error> {
        log.info(tag, "Fetch Movies with option \(sortOption), page \(page)")
        return repo.popularMovies(page: page, sortOption: sortOption)
    }
}
