//
//  Actionable.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Combine

protocol Actionable<ActionType> {
    associatedtype ActionType

    var action: AnyPublisher<ActionType, Never> { get }
}
