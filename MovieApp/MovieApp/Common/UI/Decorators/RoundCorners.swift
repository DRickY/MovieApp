//
//  RoundCorners.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct RoundCorners<T: UIView>: Decorator {
    let radius: CGFloat

    func apply(on object: T) {
        object.clipsToBounds = true
        object.layer.cornerRadius = self.radius
    }
}
