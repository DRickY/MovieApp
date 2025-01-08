//
//  ActivityIndicator.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

// Thanks to https://github.com/duyquang91/ActivityIndicator
public final class ActivityIndicator {

    private let relay = CurrentValueSubject<Int, Never>(0)

    private let lock = NSRecursiveLock()

    public let loading: AnyPublisher<Bool, Never>

    public init() {
        loading = relay.map {
            return $0 > 0
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }

    public func trackActivityOfPublisher<P: Publisher>(publisher: P) -> AnyPublisher<P.Output, P.Failure> {
        publisher
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.increment() },
                receiveCompletion: { [weak self] _ in self?.decrement() },
                receiveCancel: { [weak self] in self?.decrement() }
            )
            .eraseToAnyPublisher()
    }

    private func increment() {
        lock.lock()
        relay.send(relay.value + 1)

        lock.unlock()
    }

    private func decrement() {
        lock.lock()
        relay.send(relay.value - 1)
        lock.unlock()
    }
}

extension Publisher {
    public func trackActivity(_ activityIndicator: ActivityIndicator?, if track: Bool = true) -> AnyPublisher<Self.Output, Self.Failure> {

        guard track, let indicator = activityIndicator else {
            return self.eraseToAnyPublisher()
        }

        return indicator.trackActivityOfPublisher(publisher: self)
    }
}
