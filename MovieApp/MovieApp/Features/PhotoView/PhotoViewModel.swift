//
//  PhotoViewModel.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

enum PhotoViewNavigatorAction {
    case dismiss
}

final class PhotoViewModel {
    private var storage = DisposeStorage()

    private var _action = PassthroughSubject<PhotoViewNavigatorAction, Never>()

    private unowned let view: PhotoView

    init(view: PhotoView, url: URL) {
        self.view = view

        view.loadTrigger
            .mapTo(url)
            .bind(to: view.url)
            .store(in: &storage)

        view.closeTrigger
            .mapTo(PhotoViewNavigatorAction.dismiss)
            .weakAssign(to: \._action, on: self)
            .store(in: &storage)
    }
}

extension PhotoViewModel: Actionable {
    var action: AnyPublisher<PhotoViewNavigatorAction, Never> {
        return _action.asPublisher()
    }
}
