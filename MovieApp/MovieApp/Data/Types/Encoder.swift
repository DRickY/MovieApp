//
//  Encoder.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

protocol Encoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: Encoder {}
