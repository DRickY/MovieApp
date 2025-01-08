//
//  UITableView+Reusable.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

public typealias TableViewReusableCell = UITableViewCell & Reusable

public extension UITableView {

    final func register<T>(cellType: T.Type) where T: TableViewReusableCell {
        return self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    final func dequeueCell<T>(for indexPath: IndexPath,
                              cellType: T.Type = T.self) -> T where T: TableViewReusableCell {
        let tableCell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath)

        guard let cell = tableCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }

        return cell
    }
}
