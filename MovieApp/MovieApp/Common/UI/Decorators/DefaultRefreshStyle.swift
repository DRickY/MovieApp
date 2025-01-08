//
//  DefaultRefreshStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct DefaultRefreshStyle: Decorator {
    func apply(on object: UIRefreshControl) {
        object.attributedTitle = NSAttributedString(string: L10n.pullRefresh)
    }
}
