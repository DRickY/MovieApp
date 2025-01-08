//
//  DetailButton.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct DetailButton: Decorator {
    func apply(on object: Button) {
        object.isHidden = true

        object.setImage(Asset.play.withRenderingMode(.alwaysTemplate),
                        for: .normal)

        object.backgroundConfig = .init(normalColor: .darkText, disabledColor: .lightGray)
    }
}
