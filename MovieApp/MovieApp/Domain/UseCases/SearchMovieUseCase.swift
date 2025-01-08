//
//  SearchMovieUseCase.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

private let tag = LogTag("SearchMovieUseCase")

struct SearchMovieUseCase: UseCase {
    @Inject()
    var repo: IMovieRepository

    let page: Int

    let input: String

    func execute() -> AnyPublisher<Page<Movie>, Error> {
        log.info(tag, "Search Movies with text '\(input)', page \(page)")
        return repo.searchMovie(input: input, page: page)
    }
}
