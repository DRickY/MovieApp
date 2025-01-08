//
//  DetailScrollViewStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct DetailScrollViewStyle: Decorator {
    func apply(on object: UIScrollView) {
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        object.alwaysBounceHorizontal = true
        object.isDirectionalLockEnabled = true
        object.bounces = true
        object.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
