//
//  Coordinator.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

public protocol Coordinator: AnyObject {
    func start()

    func start(_ completion: (() -> Void)?)
}

public extension Coordinator {
    func start(_ completion: (() -> Void)?) { }

    func start() {
        start(nil)
    }
}
