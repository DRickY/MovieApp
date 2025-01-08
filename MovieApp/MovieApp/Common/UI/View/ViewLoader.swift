//
//  Loader.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

final public class ViewLoader: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        backgroundColor = Asset.overlayColor
        isHidden = true

        let loaderView = UIView(frame: .zero)
        addSubviews(loaderView)
        loaderView.addSubviews(activityIndicator)

        loaderView.backgroundColor = Asset.background
        loaderView.apply(RoundCorners(radius: defaultRadius))

        activityIndicator.color = Asset.primary
        activityIndicator.hidesWhenStopped = true

        let size = CGFloat(100)

        NSLayoutConstraint.activate([
            loaderView.widthAnchor.constraint(equalToConstant: size),
            loaderView.heightAnchor.constraint(equalTo: loaderView.widthAnchor),
            loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor)
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = self.superview?.bounds ?? .zero
    }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
