//
//  ToastView.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit

enum ToastPosition {
    case top
    case bottom
    case center
}

final class ToastView: UIView {
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(message: String, size: CGSize = CGSize(width: 250, height: 50)) {
        super.init(frame: CGRect(origin: .zero, size: size))

        setupView()
        contentLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 10
        clipsToBounds = true

        addSubview(contentLabel)

        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

extension UIView {
    func makeToast(_ message: String?,
                   duration: TimeInterval = 2,
                   position: ToastPosition = .bottom,
                   title: String? = nil,
                   image: UIImage? = nil,
                   completion: ((_ didTap: Bool) -> Void)? = nil) {

        ToastManager.shared.showToast(in: self,
                                      message: message ?? "",
                                      position: position,
                                      duration: duration)
    }
}
