//
//  UIViewController+Publishers.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine
import CombineInterception

extension UIViewController {
    public var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        let sel = #selector(UIViewController.viewDidLoad)
        return intercept(sel).toVoid()
    }

    public var viewWillAppearPublisher: AnyPublisher<Bool, Never> {
        let sel = #selector(UIViewController.viewWillAppear(_:))
        return intercept(sel)
            .mapTo(true)
            .eraseToAnyPublisher()
    }

    public var viewDidAppearPublisher: AnyPublisher<Bool, Never> {
        let sel = #selector(UIViewController.viewDidAppear(_:))
        return intercept(sel)
            .mapTo(true)
            .eraseToAnyPublisher()
    }

    public var viewWillDisappearPublisher: AnyPublisher<Bool, Never> {
        let sel = #selector(UIViewController.viewWillDisappear(_:))
        return intercept(sel)
            .mapTo(true)
            .eraseToAnyPublisher()
    }

    public var viewDidDisappearPublisher: AnyPublisher<Bool, Never> {
        let sel = #selector(UIViewController.viewDidDisappear(_:))
        return intercept(sel)
            .mapTo(true)
            .eraseToAnyPublisher()
    }

    public var isVisiblePublisher: AnyPublisher<Bool, Never> {
        let isVisible = viewWillAppearPublisher
        let isNotVisible = viewDidDisappearPublisher

        return Publishers.Merge(isVisible, isNotVisible)
            .eraseToAnyPublisher()
    }
}
