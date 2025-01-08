//
//  PopularModule.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct PopularModule: Module {
    func registerModule(using ioc: DependencyContainer) {
        ioc.register(for: IMovieRepository.self, lifetime: .singleton) { _ in
            MovieRepository()
        }
    }

    func prepareModule(using ioc: DependencyContainer) {
        //
    }

    func finalizeModule(using ioc: DependencyContainer) {
        //
    }
}
