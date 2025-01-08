//
//  Publisher+Pausable.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine
import CombineExt

extension Publisher {
    public func pausable<Pauser: Publisher>(_ pauser: Pauser) -> AnyPublisher<Self.Output, Self.Failure> where Pauser.Output == Bool, Pauser.Failure == Failure {
        return withLatestFrom(pauser) { element, paused  in
            (element, paused)
        }
        .filter { _, paused in paused }
        .map { element, _ in element }
        .eraseToAnyPublisher()
    }
}
