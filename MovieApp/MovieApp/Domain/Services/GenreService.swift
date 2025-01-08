//
//  GenreService.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

protocol IGenreService {
    var genres: [GenreDTO] { get }
    var genrePublisher: AnyPublisher<[GenreDTO], Never> { get }
}

public final class GenreService: IGenreService {
    @Inject()
    private var monitor: IConnectionMonitor

    private var fetch: AnyCancellable?

    private var storage = DisposeStorage()

    private(set) var genres: [GenreDTO] = [] {
        didSet { _genrePublisher.send(genres) }
    }

    private let _genrePublisher = SingleValueSubject<[GenreDTO], Never>()

    var genrePublisher: AnyPublisher<[GenreDTO], Never> {
        _genrePublisher.eraseToAnyPublisher()
    }

    init() {
        let timer = Timer.publish(
            every: kGenrePollingInterval,
            on: .main,
            in: .default)
            .autoconnect()
            .mapTo(true)
            .start(true)

        let connection = monitor.onConnectionStatus
            .map { $0.isReachable }
            .removeDuplicates()

        connection
            .combineLatest(timer)
            .map { $0 && $1 }
            .filter { $0 }
            .sink { [weak self] _ in
                self?.refresh()
            }
            .store(in: &storage)
    }

    private func refresh() {
        fetch = GenreUseCase().execute()
            .filter(self) { context, new in
                let oldSet = Set(context.genres)
                let newSet = Set(new)

                guard newSet != oldSet else { return false }

                return true
            }
            .ignoreFailure(setFailureType: Never.self)
            .sink { [weak self] g in
                self?.genres = g
            }
    }
}
