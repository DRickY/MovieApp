//
//  CardView.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

final public class CardView: UIView {
    public enum ShadowRadius {
        case radius(corner: CGFloat, shadow: CGFloat)
        case both(CGFloat)
    }

    public let contentView = UIView()

    public var contentBackgroundColor: UIColor = .white {
        didSet {
            setupContent()
            setNeedsDisplay()
        }
    }

    public var radius: ShadowRadius = .both(0) {
        didSet {
            setupRadious()
            setNeedsDisplay()
        }
    }

    public var shadowColor: UIColor = .black {
        didSet { setNeedsDisplay() }
    }

    public var shadowOffset: CGSize = .zero {
        didSet { setNeedsDisplay() }
    }

    public var shadowOpacity: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }

    private var shadowRadius: CGFloat {
        switch radius {
        case let .radius(_, shadowRadius):
            return shadowRadius
        case let .both(value):
            return value
        }
    }

    private var cornerRadius: CGFloat {
        switch radius {
        case let .radius(cornerRadius, _):
            return cornerRadius
        case let .both(value):
            return value
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.addSubviews(contentView)

        setupContent()

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }

    private func setupContent() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = contentBackgroundColor
        contentView.layer.cornerRadius = cornerRadius
    }

    private func setupRadious() {
        switch radius {
        case let .radius(cornerRadius, shadowRadius):
            contentView.layer.cornerRadius = cornerRadius
            layer.shadowRadius = shadowRadius
        case let .both(value):
            contentView.layer.cornerRadius = value
            layer.shadowRadius = value
        }
    }

    private func drawShadow(for rect: CGRect) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowPath = shadowPath(rect).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = window?.windowScene?.screen.scale ?? 1
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawShadow(for: rect)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    private func shadowPath(_ rect: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect, cornerRadius: shadowRadius)
    }
}
