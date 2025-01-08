//
//  PhotoViewController.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine
import Kingfisher

let ImageLoadingTag = LogTag("ImageLoadingError")

protocol PhotoView: View, LoadTriggering {
    var closeTrigger: AnyPublisher<Void, Never> { get }
    var url: AnySubscriber<URL, Never> { get }
}

extension PhotoViewController: OrientationViewController, PhotoView {
    var closeTrigger: AnyPublisher<Void, Never> {
        return closeAction.asPublisher()
    }

    var url: AnySubscriber<URL, Never> {
        AnySubscriber(self) { target, url in
            target.setImage(url: url)
        }
    }

    private func setImage(url: URL) {
        imageView.kf.cancelDownloadTask()
        imageView.kf.indicatorType = .activity

        imageView.kf.setImage(with: url, completionHandler: { [weak self] result in
            guard let this = self else { return }

            switch result {
            case .success(let value):
                this.updateMinZoomScale(imageSize: value.image.size)

            case .failure(let error):
                log.error(ImageLoadingTag, "Error loading image: \(error.localizedDescription)")
            }
        })
    }
}

final class PhotoViewController: RootViewController<PhotoViewModel> {
    private let imageView = UIImageView()

    private let scrollView = UIScrollView()

    private let closeButton = UIButton(type: .system)

    private var storage = DisposeStorage()

    private var imageTop: NSLayoutConstraint!

    private var imageLeading: NSLayoutConstraint!

    private var imageTrailing: NSLayoutConstraint!

    private var imageBottom: NSLayoutConstraint!

    private var closeAction = PassthroughSubject<Void, Never>()

    override var prefersStatusBarHidden: Bool { true }

    override func setup() {
        overrideUserInterfaceStyle = .light
        view.addSubviews(scrollView, closeButton)
        scrollView.addSubviews(imageView)
        imageView.contentMode = .scaleAspectFit
        configureScrollView()
        configureButton()
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])

        imageTop = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0)
        imageLeading = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0)
        imageTrailing = imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0)
        imageBottom = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)

        NSLayoutConstraint.activate([
            imageTop,
            imageLeading,
            imageTrailing,
            imageBottom
        ])
    }

    override func bindings() {
        imageView.apply(TapRecognizer<UIImageView>(numberOfTaps: 2))
            .sink { [weak self] _ in
                self?.changeImageScale()
            }
            .store(in: &storage)

        view.apply(SwipeRecognizer(swipeDirection: .down))
            .mapToVoid()
            .weakAssign(to: \.closeAction, on: self)
            .store(in: &storage)

        closeButton.tapPublisher
            .weakAssign(to: \.closeAction, on: self)
            .store(in: &storage)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.image.getValue { updateMinZoomScale(imageSize: $0.size) }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setPortraitOrientation()
    }

    private func configureScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .black
    }

    private func configureButton() {
        closeButton.backgroundColor = .white
        closeButton.tintColor = .black
        closeButton.setImage(Asset.close.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.layer.cornerRadius = 8
    }

    private func updateMinZoomScale(imageSize: CGSize) {
        let size = view.bounds.size
        let widthScale = size.width / imageSize.width
        let heightScale = size.height / imageSize.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale

        updateConstraints()
    }

    private func updateConstraints() {
        let size = view.bounds.size
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageTop.constant = yOffset
        imageBottom.constant = yOffset

        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageLeading.constant = xOffset
        imageTrailing.constant = xOffset

        view.layoutIfNeeded()
    }

    private func changeImageScale() {
        let isMaxZoom = scrollView.zoomScale.isEqual(to: scrollView.maximumZoomScale)
        scrollView.setZoomScale(isMaxZoom ? scrollView.minimumZoomScale : scrollView.maximumZoomScale, animated: true)
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints()
    }
}
