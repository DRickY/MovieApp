//
//  ContentMovieUseCase.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

private let tag = LogTag("ContentMovieUseCase")

struct ContentMovieUseCase: UseCase {
    @Inject()
    var repo: IMovieRepository

    let movieId: Int

    func execute() -> AnyPublisher<MovieContent, Error> {
        log.info(tag, "Open Movie Detail at id \(movieId)")
        return repo.movieContent(movieId: movieId)
    }
}
