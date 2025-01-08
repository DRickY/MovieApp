//
//  FeatureFactory.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import SafariServices

typealias FactoryResult<View: UIViewController, Action> = (view: View, actionable: any Actionable<Action>)

enum FeatureFactory {
    static var popularView: FactoryResult<PopularViewController, PopularNavigationAction> {
        let popularViewController = PopularViewController()
        let popularViewModel = PopularViewModel(view: popularViewController)
        popularViewController.setViewModel(viewModel: popularViewModel)

        return (popularViewController, popularViewModel)
    }

    static var offlineAlert: UIViewController {
        return Self.alert(title: L10n.offine, message: L10n.wificellular, actionTitle: L10n.Ok)
    }

    static func alert(title: String, message: String?, actionTitle: String) -> UIViewController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)

        alert.addAction(action)

        return alert
    }

    static func openSafari(url: URL) -> UIViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemBlue
        safariVC.dismissButtonStyle = .close

        return safariVC
    }
}
