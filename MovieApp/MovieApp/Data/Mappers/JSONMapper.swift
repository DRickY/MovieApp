//
//  JSONMapper.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

struct JSONMapper<Model: Decodable>: Mapper {
    private var logger = NetworkLogger(level: .info)

    private var decoder: JSONDecoder {
        let coder = JSONDecoder()
        coder.keyDecodingStrategy = .convertFromSnakeCase

        return coder
    }

    func map(from object: NetworkResponse) throws -> Model {
        do {
            let model = try decoder.decode(Model.self, from: object.data)

            logger.logDecoding(response: object, errorDecoding: nil, context: .trace())

            return model
        } catch {
            logger.logDecoding(response: object, errorDecoding: nil, context: .trace())

            throw AppError.mappingError(error)
        }
    }
}
