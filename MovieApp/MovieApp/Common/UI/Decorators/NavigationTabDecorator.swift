//
//  NavigationTabDecorator.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct NavigationTabDecorator: Decorator {
    func apply(on object: UINavigationBar) {
        let customNavBarAppearance = UINavigationBarAppearance()

        // Apply a red background.
        customNavBarAppearance.configureWithOpaqueBackground()

        // Apply white colored normal and large titles.
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.black]

        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance

        object.scrollEdgeAppearance = customNavBarAppearance
        object.compactAppearance = customNavBarAppearance
        object.standardAppearance = customNavBarAppearance
    }
}
