//
//  ViewStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct ViewStyle<View: UIView>: Decorator {
    func apply(on object: View) {
        object.clipsToBounds = true
    }
}
