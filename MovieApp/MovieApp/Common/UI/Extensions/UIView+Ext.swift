//
//  UIView+Ext.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        self.addArrangedSubviews(views)
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addArrangedSubview($0)
        }
    }
}

extension NSLayoutConstraint {
    @discardableResult
    func with(priority: Float) -> NSLayoutConstraint {
        self.priority = .init(priority)

        return self
    }
}
