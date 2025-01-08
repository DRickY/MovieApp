//
//  Decorator.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public protocol Decorator {
    associatedtype Object
    associatedtype Result

    func apply(on object: Object) -> Result
}

public protocol Configurable {
    @discardableResult
    func apply<D: Decorator>(_ decorator: D) -> D.Result where D.Object == Self
}

extension Configurable {
    @discardableResult
    public func apply<D: Decorator>(_ decorator: D) -> D.Result where D.Object == Self {
        return decorator.apply(on: self)
    }
}

extension NSObject: Configurable {}
