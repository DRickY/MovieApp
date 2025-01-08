//
//  DefaultTableViewStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct DefaultTableViewStyle: Decorator {
    func apply(on object: UITableView) {
        object.separatorStyle = .none
        object.rowHeight = UITableView.automaticDimension
        object.estimatedRowHeight = UITableView.automaticDimension
    }
}
