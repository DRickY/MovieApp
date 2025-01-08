//
//  GenreUseCase.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

private let genreTag = LogTag("GenreUseCase")

struct GenreUseCase: UseCase {
    @Inject()
    var repository: IGenreRepository

    func execute() -> AnyPublisher<[GenreDTO], Error> {
        log.info(genreTag, "Refreshing Genres...")
        return repository.getGenres()
    }
}
