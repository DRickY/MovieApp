//
//  ObjectDecoder.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

struct ObjectDecoder<M: Mapper>: Transformer where M.From: Decodable {

    typealias To = M.To

    let mapper: M

    init(_ mapper: M) {
        self.mapper = mapper
    }

    func transform(from: AnyPublisher<NetworkResponse, Swift.Error>) -> AnyPublisher<To, Error> {
        return from.map(using: JSONMapper<M.From>())
            .map(using: mapper)
            .eraseToAnyPublisher()
    }
}
