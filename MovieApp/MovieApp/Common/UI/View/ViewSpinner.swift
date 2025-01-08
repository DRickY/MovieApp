//
//  ViewSpinner.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

final public class ViewSpinner: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(size: CGSize) {
        super.init(frame: .init(origin: .zero, size: size))
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubviews(activityIndicator)
        activityIndicator.color = Asset.primary
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
