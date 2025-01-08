//
//  DefaultTableCellStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct DefaultTableCellStyle<V: UITableViewCell>: Decorator {
    func apply(on object: V) {
        object.selectionStyle = .none
    }
}
