//
//  Mapper.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public protocol Mapper {
    associatedtype From
    associatedtype To

    func map(from object: From) throws -> To
}
