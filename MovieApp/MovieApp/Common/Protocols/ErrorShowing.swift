//
//  ErrorShowing.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit

public protocol ErrorShowing: AnyObject {
    func showError(error: AppError)
}

extension ErrorShowing where Self: UIViewController {
    func showError(error: AppError) {
        error.handle(
            ToastErrorHandler(view: view)
        )
    }
}

struct ToastErrorHandler: ErrorHandler {
    weak var view: UIView?

    init(view: UIView) {
        self.view = view
    }

    func handle(error: AppError) -> Bool {
        switch error {
        case .serverError:
            view?.makeToast("Server Error")
        case .connectionError:
            view?.makeToast(L10n.connectionLost)
        case .unexpectedError, .httpError:
            view?.makeToast(L10n.unexpectedError)
        case .mappingError:
            view?.makeToast(L10n.unexpectedError)
        case .validationError:
            return false
        }

        return true
    }
}
