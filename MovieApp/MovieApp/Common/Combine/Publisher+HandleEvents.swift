//
//  Publisher+HandleEvents.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

extension Publisher {
    public func onEvents(onSubscription: ((any Subscription) -> Void)? = nil, onOutput: ((Self.Output) -> Void)? = nil, onError: ((Self.Failure) -> Void)? = nil, onFinish: (() -> Void)? = nil, onCancel: (() -> Void)? = nil, onRequest: ((Subscribers.Demand) -> Void)? = nil) -> Publishers.HandleEvents<Self> {

        return self.handleEvents(
            receiveSubscription: onSubscription,
            receiveOutput: onOutput,
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    onFinish?()
                case let .failure(error):
                    onError?(error)
                }
            },
            receiveCancel: onCancel,
            receiveRequest: onRequest)
    }

    public func onEvents<Target: AnyObject>(with target: Target, onSubscription: ((Target, any Subscription) -> Void)? = nil, onOutput: ((Target, Self.Output) -> Void)? = nil, onError: ((Target, Self.Failure) -> Void)? = nil, onFinish: ((Target) -> Void)? = nil, onCancel: ((Target) -> Void)? = nil, onRequest: ((Target, Subscribers.Demand) -> Void)? = nil) -> Publishers.HandleEvents<Self> {

        return handleEvents(
            receiveSubscription: { [weak target] value in
                guard let strong = target else { return }
                onSubscription?(strong, value)
            },
            receiveOutput: { [weak target] value in
                guard let strong = target else { return }

                onOutput?(strong, value)
            },
            receiveCompletion: { [weak target] completion in
                guard let strong = target else { return }

                switch completion {
                case .finished:
                    onFinish?(strong)
                case let .failure(error):
                    onError?(strong, error)
                }
            },
            receiveCancel: { [weak target] in
                guard let strong = target else { return }

                onCancel?(strong)
            },
            receiveRequest: { [weak target] value in
                guard let strong = target else { return }

                onRequest?(strong, value)
            })
    }
}
