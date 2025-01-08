//
//  RootViewController.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

let deinitTag = LogTag("[DEINIT]")

public class RootViewController<Model>: UIViewController {
    private var _model: Model?

    public var model: Model {
        guard let viewModel = _model else {
            fatalError("Please set ViewModel before using this property")
        }

        return viewModel
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        _setup()
    }

    func setViewModel(viewModel: Model) {
        _model = viewModel
    }

    private func _setup() {
        setup()
        setupLayout()
        bindings()
    }

    /// Do not call super method in your subclass
    func setup() {
        //
    }

    /// Do not call super method in your subclass
    func setupLayout() {
        //
    }

    /// Do not call super method in your subclass
    func bindings() {

    }

    deinit {
        _model = nil
        log.info(deinitTag, "Instance of -> \(Self.self)")
    }
}
