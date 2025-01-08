//
//  UIImageView+Ext.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ url: URL?) {
        self.kf.cancelDownloadTask()
        self.kf.indicatorType = .activity

        self.kf.setImage(
            with: url,
            placeholder: url != nil ? nil : Asset.gallery,
            options: [.cacheMemoryOnly, .fromMemoryCacheOrRefresh]
        )
    }
}
