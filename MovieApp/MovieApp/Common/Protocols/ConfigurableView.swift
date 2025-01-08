//
//  ConfigurableView.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public protocol ConfigurableView {
    associatedtype Model

    func configure(with model: Model)
}
