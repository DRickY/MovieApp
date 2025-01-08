//
//  AnyHashable+Ex.swift
//
//  MovieApp
//  Created by Dmytro on 08.01.2025.
//

public extension AnyHashable {
    static func key<T>(for type: T.Type) -> AnyHashable {
        return String(describing: type)
    }
}
