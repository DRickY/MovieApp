//
//  ToastManager.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

final class ToastManager {
    static let shared = ToastManager()
    private var toasts: [UIView] = []
    private let spacing: CGFloat = 10

    private init() {}

    func showToast(in view: UIView,
                   message: String,
                   position: ToastPosition = .bottom,
                   size: CGSize = CGSize(width: 250, height: 50),
                   duration: TimeInterval = 2.0) {

        let toast = ToastView(message: message, size: size)
        toast.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toast)
        toasts.append(toast)

        let horizontalConstraint = toast.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        var verticalConstraint: NSLayoutConstraint
        switch position {
        case .top:
            verticalConstraint = toast.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20 + CGFloat(toasts.count - 1) * (size.height + spacing))
        case .center:
            verticalConstraint = toast.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        case .bottom:
            verticalConstraint = toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20 - CGFloat(toasts.count - 1) * (size.height + spacing))
        }

        NSLayoutConstraint.activate([
            horizontalConstraint,
            verticalConstraint,
            toast.widthAnchor.constraint(equalToConstant: size.width),
            toast.heightAnchor.constraint(equalToConstant: size.height)
        ])

        toast.alpha = 0

        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: 0.3, animations: {
                    toast.alpha = 0
                }) { _ in
                    toast.removeFromSuperview()
                    self.toasts.removeAll { $0 == toast }
                    self.repositionToasts(in: view, position: position, size: size)
                }
            }
        }
    }

    private func repositionToasts(in view: UIView, position: ToastPosition, size: CGSize) {
        for (index, toast) in toasts.enumerated() {
            switch position {
            case .top:
                toast.frame.origin.y = 20 + CGFloat(index) * (size.height + spacing)
            case .bottom:
                toast.frame.origin.y = view.frame.height - 20 - size.height - CGFloat(index) * (size.height + spacing)
            case .center:
                break
            }
        }
    }
}
