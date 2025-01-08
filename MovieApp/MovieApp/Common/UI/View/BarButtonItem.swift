//
//  BarButtonItem.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit

public class BarButtonItem: UIBarButtonItem {
    public struct BackgroundConfig {
        let normalColor: UIColor
        let disabledColor: UIColor

        public init(normalColor: UIColor, disabledColor: UIColor) {
            self.normalColor = normalColor
            self.disabledColor = disabledColor
        }

        func colorFor(enabled: Bool) -> UIColor {
            return enabled ? normalColor : disabledColor
        }
    }

    override public var isEnabled: Bool {
        didSet {
            setupBackgroundColor()
        }
    }

    public var backgroundConfig: BackgroundConfig? {
        didSet {
            setupBackgroundColor()
        }
    }

    private func setupBackgroundColor() {
        guard let config = backgroundConfig else { return }
        tintColor = config.colorFor(enabled: isEnabled)
    }
}

extension UIBarButtonItem {
    public func setEnabled(_ value: Bool) {
        isEnabled = value
    }
}

public class Button: UIButton {
    public struct BackgroundConfig {
        let normalColor: UIColor
        let disabledColor: UIColor

        public init(normalColor: UIColor, disabledColor: UIColor) {
            self.normalColor = normalColor
            self.disabledColor = disabledColor
        }

        func colorFor(enabled: Bool) -> UIColor {
            return enabled ? normalColor : disabledColor
        }
    }

    override public var isEnabled: Bool {
        didSet {
            setupBackgroundColor()
        }
    }

    public var backgroundConfig: BackgroundConfig? {
        didSet {
            setupBackgroundColor()
        }
    }

    private func setupBackgroundColor() {
        guard let config = backgroundConfig else { return }
        tintColor = config.colorFor(enabled: isEnabled)
    }
}

extension Button {
    public func setEnabled(_ value: Bool) {
        isEnabled = value
    }
}
