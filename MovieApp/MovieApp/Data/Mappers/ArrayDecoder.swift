//
//  ArrayDecoder.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

struct ArrayDecoder<M: Mapper>: Transformer where M.From: Decodable {

    typealias From = NetworkResponse
    typealias To = [M.To]

    let mapper: M

    init(_ mapper: M) {
        self.mapper = mapper
    }

    func transform(from: AnyPublisher<From, Error>) -> AnyPublisher<To, Error> {
        let values = from.map(using: JSONMapper<[M.From]>())

        return values.tryMap { try $0.map(self.mapper.map) }
            .eraseToAnyPublisher()
    }
}
