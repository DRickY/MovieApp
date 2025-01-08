//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine

final class MovieDetailViewController: RootViewController<IMovieDetailViewModel> {
    private var storage = DisposeStorage()

    private var posterImageTap = PassthroughSubject<Void, Never>()

    private var backTap = PassthroughSubject<Void, Never>()

    private lazy var scrollView = UIScrollView()

    private lazy var contentView = UIView()

    private lazy var posterView = UIImageView()

    private lazy var titleLabel = UILabel()

    private lazy var countryLabel = UILabel()

    private lazy var genreLabel = UILabel()

    private lazy var trailerButtonView = Button(type: .system)

    private lazy var ratingLabel = UILabel()

    private lazy var textView = UITextView()

    lazy var viewLoader = ViewLoader()

    override func setup() {
        view.addSubviews(scrollView)

        let views = [posterView, titleLabel, countryLabel, genreLabel, trailerButtonView, ratingLabel, textView]

        scrollView.addSubviews(contentView)

        contentView.addSubviews(views)

        contentView.addSubview(viewLoader)

        scrollView.apply(DetailScrollViewStyle())

        textView.apply(DetailTextViewStyle())

        posterView.apply(ViewStyle())

        titleLabel.apply(DetailLableStyle(font: .bold(32), lines: 2))

        countryLabel.apply(DetailLableStyle(font: .semibold(17),
                                            textColor: .darkGray))

        genreLabel.apply(DetailLableStyle(font: .semibold(17),
                                          textColor: .darkGray,
                                          lines: 3))

        ratingLabel.apply(DetailLableStyle(font: .bold(18)))

        trailerButtonView.apply(DetailButton())
    }

    override func setupLayout() {
        let pad: CGFloat = 8
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Poster View
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor,
                                               multiplier: 0.75),

            // Title View
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor,
                                            constant: pad),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: pad),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -pad),

            // Country View
            countryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                              constant: 4),
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: pad),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -pad),

            // Genre Label
            genreLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor,
                                            constant: pad),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: pad),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -pad),

            // Trailer View
            trailerButtonView.topAnchor.constraint(equalTo: genreLabel.bottomAnchor,
                                                   constant: pad),

            trailerButtonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: pad),

            trailerButtonView.widthAnchor.constraint(equalToConstant: 36),

            trailerButtonView.heightAnchor.constraint(equalTo: trailerButtonView.widthAnchor),

            // Rating View
            ratingLabel.centerYAnchor.constraint(equalTo: trailerButtonView.centerYAnchor),

            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -16),

            // Text View
            textView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor,
                                          constant: 22),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: pad),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -pad),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -pad)
        ])
    }

    override func bindings() {
        apply(BarItemStyle(image: Asset.back, place: .left))
            .weakAssign(to: \.backTap, on: self)
            .store(in: &storage)

        posterView.apply(TapRecognizer(numberOfTaps: 1))
            .weakAssign(to: \.posterImageTap, on: self)
            .store(in: &storage)
    }
}

extension MovieDetailViewController: ConfigurableView {
    func configure(with model: MovieContent) {
        title = model.title
        titleLabel.text = model.title
        countryLabel.text = model.contryDate
        genreLabel.text = model.genre
        ratingLabel.text = L10n.rating + ": \(model.average)"
        textView.text = model.overview
        trailerButtonView.isHidden = model.videoContent == nil

        if model.backdrop != nil {
            posterView.contentMode = .scaleAspectFill
        } else {
            posterView.contentMode = .scaleAspectFit
        }

        posterView.setImage(model.backdrop ?? model.poster)
    }

    func disable(_ enable: Bool) {
        trailerButtonView.setEnabled(enable)
    }
}

extension MovieDetailViewController: MovieDetailView {
    var posterImageTapTrigger: AnyPublisher<Void, Never> {
        posterImageTap.asPublisher()
    }

    var trailerTapTrigger: AnyPublisher<Void, Never> {
        trailerButtonView.tapPublisher
    }

    var backTapTrigger: AnyPublisher<Void, Never> {
        backTap.asPublisher()
    }

    var content: AnySubscriber<MovieContent, Never> {
        AnySubscriber(self) { target, model in
            target.configure(with: model)
        }
    }

    var disable: AnySubscriber<Bool, Never> {
        AnySubscriber(self) { target, toggle in
            target.disable(toggle)
        }
    }
}

extension MovieContent {
    fileprivate var contryDate: String {
        let movieRelease = (releaseDate.isEmpty) ? releaseDate : ", " + releaseDate
        return  country + movieRelease
    }
}
