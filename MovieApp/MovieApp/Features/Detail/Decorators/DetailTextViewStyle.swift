//
//  DetailTextViewStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct DetailTextViewStyle: Decorator {
    func apply(on object: UITextView) {
        object.textColor = .black
        object.backgroundColor = .clear
        object.textColor = Asset.primary
        object.font = .systemFont(ofSize: 17)
        object.isUserInteractionEnabled = true
        object.isSelectable = true
        object.isEditable = false
        object.isScrollEnabled = false
        object.textContainerInset = .zero
        object.textAlignment = .center
    }
}
