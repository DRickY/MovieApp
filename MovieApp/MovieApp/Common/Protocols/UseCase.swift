//
//  UseCase.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

public protocol UseCase {
    associatedtype Result

    func execute() -> Result
}
