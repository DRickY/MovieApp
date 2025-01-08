//
//  PaginationTableViewShowing.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

import UIKit
import Combine

public protocol PaginationTableViewShowing: AnyObject {
    var tableView: UITableView { get }
    var viewSpinner: ViewSpinner { get }
}

extension PaginationTableViewShowing {
    public var loadingFooterTrigger: AnySubscriber<Bool, Never> {
        return AnySubscriber(tableView) { [weak self] target, trigger in
            if trigger {
                self?.viewSpinner.startAnimating()
                target.tableFooterView = self?.viewSpinner
            } else {
                self?.viewSpinner.stopAnimating()
                target.tableFooterView = UIView(frame: .zero)
            }
        }
    }
}
