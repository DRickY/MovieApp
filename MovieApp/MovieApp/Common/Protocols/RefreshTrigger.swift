//
//  RefreshTrigger.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine
import CombineCocoa

public protocol RefreshTrigger: AnyObject {
    var refreshControl: UIRefreshControl { get }
}

public extension RefreshTrigger {
    var refreshTrigger: AnyPublisher<Void, Never> {
        return refreshControl.controlEventPublisher(for: .valueChanged)
    }

    var isRefreshing: AnySubscriber<Bool, Never> {
        return AnySubscriber<Bool, Never>(refreshControl) { target, refresh in
            if refresh {
                target.beginRefreshing()
            } else {
                target.endRefreshing()
            }
        }
    }
}
