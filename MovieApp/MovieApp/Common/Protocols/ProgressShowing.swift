//
//  ProgressShowing.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine

public protocol ProgressShowing: AnyObject {
    var viewLoader: ViewLoader { get }
}

extension ProgressShowing {
    var isLoading: AnySubscriber<Bool, Never> {
        return AnySubscriber(viewLoader) { target, trigger in
            target.isHidden = !trigger
            if trigger {
                target.startAnimating()
            } else {
                target.stopAnimating()
            }
        }
    }
}
