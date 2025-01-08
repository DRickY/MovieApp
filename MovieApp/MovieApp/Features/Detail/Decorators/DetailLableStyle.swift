//
//  DetailLableStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct DetailLableStyle: Decorator {
    let font: UIFont
    let textColor: UIColor
    let lines: Int

    init(font: UIFont, textColor: UIColor = .black, lines: Int = 1) {
        self.font = font
        self.textColor = textColor
        self.lines = lines
    }

    func apply(on object: UILabel) {
        object.font = font
        object.textColor = textColor
        object.numberOfLines = lines
    }
}
