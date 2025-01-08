//
//  TapRecognizer.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine
import CombineCocoa

struct TapRecognizer<T: UIView>: Decorator {
    let numberOfTaps: Int

    init(numberOfTaps: Int = 1) {
        self.numberOfTaps = numberOfTaps
    }

    func apply(on object: T) -> AnyPublisher<Void, Never> {
        object.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        tapGestureRecognizer.numberOfTapsRequired = numberOfTaps
        object.addGestureRecognizer(tapGestureRecognizer)

        return tapGestureRecognizer.tapPublisher.mapTo(()).asPublisher()
    }
}

struct SwipeRecognizer<T: UIView>: Decorator {
    let swipeDirection: UISwipeGestureRecognizer.Direction

    func apply(on object: T) -> AnyPublisher<UISwipeGestureRecognizer.Direction, Never> {
        object.isUserInteractionEnabled = true
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = swipeDirection
        object.addGestureRecognizer(swipe)

        return swipe.swipePublisher.map(\.direction).asPublisher()
    }
}
