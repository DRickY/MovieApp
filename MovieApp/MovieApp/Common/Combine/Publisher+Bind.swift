//
//  Publisher+Bind.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

extension Publisher {
    func bind<B: Subscriber>(to subscriber: B) -> AnyCancellable
    where B.Failure == Failure, B.Input == Output {
        handleEvents(receiveSubscription: { subscription in
            subscriber.receive(subscription: subscription)
        })
        .sink(receiveCompletion: {
            subscriber.receive(completion: $0)
        }, receiveValue: { value in
            _ = subscriber.receive(value)
        })
    }
}

extension Publisher where Failure == Never {
    func bind<B: Subscriber>(to subscriber: B) -> AnyCancellable
    where B.Failure == Never, B.Input == Output {
        handleEvents(receiveSubscription: { subscription in
            subscriber.receive(subscription: subscription)
        })
        .sink(receiveCompletion: {
            subscriber.receive(completion: $0)
        }, receiveValue: { value in
            _ = subscriber.receive(value)
        })
    }

    func bind<B: Subscriber, T>(to subscriber: B, _ transform: @escaping (Output) -> T) -> AnyCancellable
    where B.Failure == Never, B.Input == T {
        handleEvents(receiveSubscription: { subscription in
            subscriber.receive(subscription: subscription)
        })
        .sink(receiveCompletion: {
            subscriber.receive(completion: $0)
        }, receiveValue: { value in
            _ = subscriber.receive(transform(value))
        })
    }
}
