//
//  PopularLabelStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct PopularLabel: Decorator {
    let lines: Int
    let fontSize: CGFloat
    let bold: Bool

    init(fontSize: CGFloat, lines: Int = 2, bold: Bool = false) {
        self.lines = lines
        self.fontSize = fontSize
        self.bold = bold
    }

    func apply(on object: UILabel) {
        object.numberOfLines = lines
        if bold {
            object.font = .boldSystemFont(ofSize: fontSize)
        } else {
            object.font = .systemFont(ofSize: fontSize)
        }
    }
}
