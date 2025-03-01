//
//  Reusable.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
