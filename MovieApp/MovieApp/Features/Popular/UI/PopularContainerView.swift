//
//  PopularContainerView.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

final class PopularContainerView: AppView, ConfigurableView {
    private lazy var imageIconView = UIImageView()
    private lazy var lableView = UILabel()
    private lazy var stackView = UIStackView()

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageIconView.image = nil
        self.lableView.text = nil
    }

    override func setup() {
        lableView.font = .semibold(14)
        let views = [lableView, imageIconView]
        stackView.addArrangedSubviews(views)
        addSubviews(stackView)

        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .trailing
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),

            imageIconView.heightAnchor.constraint(equalToConstant: 15),
            imageIconView.widthAnchor.constraint(equalTo: imageIconView.heightAnchor)
        ])
    }

    func configure(with model: (image: UIImage, title: String)) {
        let (image, title) = model
        self.imageIconView.image = image
        self.lableView.text = title
    }
}
