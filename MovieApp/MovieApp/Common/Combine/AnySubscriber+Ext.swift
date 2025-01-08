//
//  Binder.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

extension AnySubscriber {
    public init<Target: AnyObject>(_ target: Target,
                                   scheduler: any Scheduler = DispatchQueue.main,
                                   binding: @escaping (Target, Input) -> Void) {
        self.init(
            receiveSubscription: { $0.request(.unlimited) },
            receiveValue: { [weak target] value in
                guard let aTraget = target else { return .none }
                scheduler.schedule {
                    binding(aTraget, value)
                }

                return .unlimited
            },
            receiveCompletion: { _ in })
    }

    public init<Target: AnyObject>(
        with target: Target,
        onSubscription: ((Target, any Subscription) -> Void)? = nil,
        onValue: ((Target, Input) -> Void)? = nil,
        onError: ((Target, Failure) -> Void)? = nil,
        onCompleted: ((Target) -> Void)? = nil) {
        self.init(
            receiveSubscription: { [weak target] in
                guard let aTarget = target else {
                    $0.request(.unlimited)
                    return
                }

                guard let handler = onSubscription else {
                    $0.request(.unlimited)
                    return
                }

                handler(aTarget, $0)
            },
            receiveValue: { [weak target] in
                guard let aTarget = target else { return .none }
                onValue?(aTarget, $0)
                return .unlimited
            },
            receiveCompletion: { [weak target] in
                guard let aTarget = target else { return }
                switch $0 {
                case .finished:
                    onCompleted?(aTarget)
                case .failure(let error):
                    onError?(aTarget, error)
                }
            })
    }

    public init(
        onSubscription: ((any Subscription) -> Void)? = nil,
        onValue: ((Input) -> Void)? = nil,
        onError: ((Failure) -> Void)? = nil,
        onCompleted: (() -> Void)? = nil) {
        self.init(
            receiveSubscription: {
                guard let handler = onSubscription else {
                    $0.request(.unlimited)
                    return
                }

                handler($0)
            },
            receiveValue: {
                onValue?($0)
                return .unlimited
            },
            receiveCompletion: {
                switch $0 {
                case .finished:
                    onCompleted?()
                case .failure(let error):
                    onError?(error)
                }
            })
    }
}

extension AnySubscriber where Failure == Never {
    init(
        onSubscription: ((Subscription) -> Void)? = nil,
        onValue: @escaping ((Input) -> Subscribers.Demand),
        onCompletion: ((Subscribers.Completion<Never>) -> Void)? = nil
    ) {
        self.init(
            receiveSubscription: { onSubscription?($0) },
            receiveValue: { onValue($0) },
            receiveCompletion: { onCompletion?($0) }
        )
    }
}
