//
//  UIViewController+Ext.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard self.parent != nil else { return }

        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

extension UIViewController {
    public func presenting(_ viewControllerToPresent: UIViewController,
                           isModalInPresentation: Bool = true,
                           modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                           animated flag: Bool = true,
                           completion: (() -> Void)? = nil) {
        viewControllerToPresent.isModalInPresentation = isModalInPresentation
        viewControllerToPresent.modalPresentationStyle = modalPresentationStyle
        self.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

extension UIViewController {
    public func searchControllerBarResignResponder() {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
}

extension UIViewController {
    static var topViewController: UIViewController? {
        UIApplication.shared.topViewController()
    }
}

extension UIApplication {
    func topViewController(base: UIViewController? = UIApplication.shared.rootViewController) -> UIViewController? {
        if let navigation = base as? UINavigationController {
            return topViewController(base: navigation.visibleViewController)
        }

        if let tabBarController = base as? UITabBarController, let selected = tabBarController.selectedViewController {
            return topViewController(base: selected)
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }

    var rootViewController: UIViewController? {
        UIApplication.shared.keyWindowInConnectedScenes?.rootViewController
    }

    var keyWindowInConnectedScenes: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
