//
//  Shadow.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct ShadowCardDecorator<T: UIView>: Decorator {
    func apply(on object: CardView) {
        object.shadowColor = UIColor(white: 0, alpha: 0.213)
        object.shadowOffset = CGSize(width: 0.5, height: -0.5)
        object.shadowOpacity = 0.8
        object.radius = .radius(corner: 12, shadow: 8)
        object.contentBackgroundColor = .white
    }
}
