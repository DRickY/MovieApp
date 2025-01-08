//
//  UINavigationItem+Ext.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

extension UINavigationItem {
    func enableRightBarItem(_ value: Bool) {
        rightBarButtonItem?.setEnabled(value)
    }
}
