//
//  TableViewCell.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

class TableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        _setup()
    }

    private func _setup() {
        setup()
        setupLayout()
    }

    /// Do not call super method in your subclass
    func setup() {
        //
    }

    /// Do not call super method in your subclass
    func setupLayout() {
        //
    }
}
