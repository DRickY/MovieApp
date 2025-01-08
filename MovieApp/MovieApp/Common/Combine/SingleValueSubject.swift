//
//  SingleValueSubject.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

final class SingleValueSubject<Output, Failure>: Subject where Failure: Error {
    enum State {
        case initial
        case value(Output)
    }

    private let currentSubject = CurrentValueSubject<State, Failure>(.initial)

    private let receiver: AnyPublisher<Output, Failure>

    init() {
        receiver = currentSubject
            .compactMap {
                switch $0 {
                case .initial: return nil
                case .value(let value): return value
                }
            }
            .eraseToAnyPublisher()
    }

    func send(_ value: Output) {
        currentSubject.send(.value(value))
    }

    func send(completion: Subscribers.Completion<Failure>) {
        currentSubject.send(completion: completion)
    }

    func send(subscription: Subscription) {
        currentSubject.send(subscription: subscription)
    }

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        receiver.receive(subscriber: subscriber)
    }
}
