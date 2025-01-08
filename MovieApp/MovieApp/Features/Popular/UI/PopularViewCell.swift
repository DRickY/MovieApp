//
//  PopularViewCell.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

final class PopularViewCell: TableViewCell, Reusable, ConfigurableView {

    private lazy var shadowView = CardView()

    private lazy var posterView = UIImageView()

    private lazy var ratingView = PopularContainerView()

    private lazy var yearView = PopularContainerView()

    private lazy var titleLable = UILabel()

    private lazy var genreLable = UILabel()

    private var root: UIView { shadowView.contentView }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterView.image = nil
        titleLable.text = nil
        genreLable.text = nil
        ratingView.prepareForReuse()
        yearView.prepareForReuse()
    }

    override func setup() {
        apply(DefaultTableCellStyle())
        shadowView.apply(ShadowCardDecorator())
        contentView.addSubviews(shadowView)
        root.addSubviews(posterView)
        let views = [titleLable, ratingView, genreLable, yearView]
        root.addSubviews(views)
        titleLable.apply(PopularLabel(fontSize: 16, bold: true))
        genreLable.apply(PopularLabel(fontSize: 14))
    }

    override func setupLayout() {
        let padding = CGFloat(16)

        titleLable.setContentHuggingPriority(.init(249), for: .horizontal)

        titleLable.setContentCompressionResistancePriority(.init(248), for: .horizontal)

        genreLable.setContentHuggingPriority(.init(248), for: .horizontal)

        genreLable.setContentCompressionResistancePriority(.init(248), for: .horizontal)

        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])

        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: root.topAnchor),
            posterView.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor, multiplier: 1.23)
        ])

        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 12),
            titleLable.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 8),

            ratingView.topAnchor.constraint(equalTo: titleLable.topAnchor),

            ratingView.leadingAnchor.constraint(equalTo: titleLable.trailingAnchor, constant: 8),

            ratingView.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            genreLable.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 6),

            genreLable.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),

            genreLable.bottomAnchor.constraint(equalTo: root.bottomAnchor, constant: -8),

            yearView.topAnchor.constraint(equalTo: genreLable.topAnchor),

            yearView.leadingAnchor.constraint(equalTo: genreLable.trailingAnchor, constant: 8),

            yearView.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -8)
        ])
    }

    func configure(with model: Movie) {
        titleLable.text = model.title
        genreLable.text = model.genre

        if model.backdrop != nil {
            posterView.contentMode = .scaleAspectFill
        } else {
            posterView.contentMode = .scaleAspectFit
        }

        posterView.setImage(model.backdrop ?? model.poster)

        ratingView.configure(with: (Asset.favorite, model.average))
        yearView.configure(with: (Asset.calendar, model.year))
    }
}
