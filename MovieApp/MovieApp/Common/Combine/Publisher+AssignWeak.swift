//
//  Publisher+AssignWeak.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

extension Publisher {
    func weakAssign<Root: AnyObject, Output>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        on object: Root
    ) -> AnyCancellable where Output == Self.Output {
        self.sink { _ in
            // Empty
        } receiveValue: { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    func weakAssign<Root: AnyObject, Output>(
        to keyPath: ReferenceWritableKeyPath<Root, Output?>,
        on object: Root
    ) -> AnyCancellable where Output == Self.Output {
        sink { _ in
            // Empty
        } receiveValue: { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    func weakAssign<Root: AnyObject, S: Subject>(
        to keyPath: KeyPath<Root, S>,
        on object: Root
    ) -> AnyCancellable
    where S.Output == Self.Output, S.Failure == Never, S.Failure == Self.Failure {
        sink { _ in
            // Empty
        } receiveValue: { [weak object] value in
            object?[keyPath: keyPath].send(value)
        }
    }

    func weakAssign<Root: AnyObject, S: Subject>(
        to keyPath: ReferenceWritableKeyPath<Root, S>,
        on object: Root
    ) -> AnyCancellable
    where S.Output == Self.Output, S.Failure == Never, S.Failure == Self.Failure {
        sink { _ in
            // Empty
        } receiveValue: { [weak object] value in
            object?[keyPath: keyPath].send(value)
        }
    }

    func weakAssign<Root: AnyObject, S: Subject, M>(
        to keyPath: ReferenceWritableKeyPath<Root, S>,
        on object: Root,
        _ transform: @escaping (Output) -> M
    ) -> AnyCancellable
    where S.Failure == Failure, S.Output == M {
        sink { _ in
            // Empty
        } receiveValue: { [weak object] value in
            object?[keyPath: keyPath].send(transform(value))
        }
    }

    func weakMap<Root: AnyObject, S: Subject, M>(
        to keyPath: ReferenceWritableKeyPath<Root, S>,
        on object: Root,
        _ transform: @escaping (Output) -> M
    ) -> Publishers.Map<Self, Output>
    where S.Failure == Failure, S.Output == M {
        return self.mapValue { [weak object] value in
            object?[keyPath: keyPath].send(transform(value))
        }
    }
}
