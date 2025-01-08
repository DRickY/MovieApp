//
//  LoadTriggering.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine
import CombineCocoa

public protocol LoadTriggering: AnyObject {
    var loadTrigger: AnyPublisher<Void, Never> { get }
}

extension LoadTriggering where Self: UIViewController {
    var loadTrigger: AnyPublisher<Void, Never> {
        let didBecomeActiveNotification = NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification).mapTo(true)

        return Publishers.Merge(
            didBecomeActiveNotification,
            self.viewWillAppearPublisher
        )
        .pausable(self.isVisiblePublisher)
        .prepend(true)
        .removeDuplicates()
        .toVoid()
        .asPublisher()
    }
}
