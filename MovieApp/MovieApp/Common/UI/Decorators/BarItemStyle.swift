//
//  BarItemStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine
import CombineCocoa

enum ButtonPlace {
    case left
    case right
}

struct BarItemStyle<T: UIViewController>: Decorator {
    let image: UIImage
    let place: ButtonPlace

    func apply(on object: T) -> AnyPublisher<Void, Never> {
        let item = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)

        switch place {
        case .left: object.navigationItem.leftBarButtonItem = item
        case .right: object.navigationItem.rightBarButtonItem = item
        }

        return item.tapPublisher
    }
}
