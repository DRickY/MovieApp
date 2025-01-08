//
//  Publisher+Mapper.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Combine

extension Publisher {
    public func map<M: Mapper>(using mapper: M) -> AnyPublisher<M.To, Error> where M.From == Output {
        return tryMap(mapper.map).eraseToAnyPublisher()
    }

    public func tryMap<M: Mapper>(using mapper: M) -> Publishers.TryMap<Self, M.To> where M.From == Output {
        return self.tryMap(mapper.map)
    }
}

extension Publisher {
    public func toVoid() -> AnyPublisher<Void, Failure> {
        return self.map { _ in }.eraseToAnyPublisher()
    }

    public func mapTo<Value>(_ value: Value) -> Publishers.Map<Self, Value> {
        return self.map { _ in value }
    }

    func mapValue(_ callback: @escaping (Output) -> Void) -> Publishers.Map<Self, Output> {
        self.map {
            callback($0)
            return $0
        }
    }

    func mapValue(_ callback: @escaping (Output) throws -> Void) throws -> Publishers.TryMap<Self, Output> {
        self.tryMap {
            try callback($0)
            return $0
        }
    }

    func `catch`(_ callback: @escaping (Failure) throws -> Void) -> Publishers.TryCatch<Self, Self> {
        tryCatch { e -> Self in
            try callback(e)
            throw e
        }
    }

    func start<T>(_ value: T) -> AnyPublisher<T, Self.Failure> where Self.Output == T {
        return self.merge(with: emitOnce(value)).eraseToAnyPublisher()
    }
}
