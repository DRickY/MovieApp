//
//  GenreRepository.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

protocol IGenreRepository {
    func getGenres() -> AnyPublisher<[GenreDTO], Error>
}

struct GenreRepository: IGenreRepository {
    @Inject()
    var api: IAPIClient

    func getGenres() -> AnyPublisher<[GenreDTO], Error> {
        return api.execute(request: GenresRequest(),
                           mapper: GenreMapper()
        )
    }
}
