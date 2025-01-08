//
//  OrientationViewController.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

protocol OrientationViewController {}

extension OrientationViewController where Self: UIViewController {
    func setPortraitOrientation() {
        guard isBeingDismissed, let parentViewController = presentingViewController else {
            return
        }
        if parentViewController is OrientationViewController {
            return
        }
        let portrait = UIDeviceOrientation.portrait
        UIDevice.current.setValue(portrait.rawValue, forKey: "orientation")
    }
}
