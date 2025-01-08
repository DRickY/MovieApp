//
//  ImageURLMapper.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

enum ImageSize {
    case small
    case large
}

extension ImageSize {
    var configSize: ConfigImageSize {
        switch self {
        case .small:
            return .small
        case .large:
            return .large
        }
    }
}

struct ImageURLMapper: Mapper {
    @Inject()
    private var config: IAppConfig

    let imageSize: ImageSize

    func map(from path: String) throws -> URL {
        guard let url = URL(string: config.baseImageURL(size: imageSize.configSize)) else {
            throw AppError.unexpectedError
        }

        return url.appendingPathComponent(path, conformingTo: .url)
    }
}
