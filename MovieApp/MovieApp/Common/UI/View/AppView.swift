//
//  AppView.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

class AppView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

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

    func prepareForReuse() {

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
