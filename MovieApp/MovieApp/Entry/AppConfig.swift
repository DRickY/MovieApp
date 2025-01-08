//
//  AppConfig.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public enum ConfigImageSize {
    case small
    case large

    var size: String {
        switch self {
        case .small:
            "w780"
        case .large:
            "w1280"
        }
    }
}

public enum ConfigVideoProvider: Hashable {
    case youtube
    case custom(String)
}

protocol IAppConfig {
    var env: Environment { get }

    var baseURL: String { get }

    var apiKey: String { get }

    var locale: String { get }

    func baseImageURL(size: ConfigImageSize) -> String

    func videoProvider(type: ConfigVideoProvider) -> String?
}

public struct AppConfig: IAppConfig {
    private let defaultLocale = "en-US"
    private var videoProviders: [ConfigVideoProvider: String] {
        return [.youtube: "https://www.youtube.com/embed/"]
    }

    public let env: Environment

    public var baseURL: String {
        switch env {
        case .development, .sandbox, .production:
            return "https://api.themoviedb.org"
        }
    }

    var locale: String {
        return Locale.current.collatorIdentifier ?? defaultLocale
    }

    public func baseImageURL(size: ConfigImageSize = .large) -> String {
        switch env {
        case .development, .sandbox, .production:
            return "https://image.tmdb.org/t/p/\(size.size)"
        }
    }

    public func videoProvider(type: ConfigVideoProvider) -> String? {
        videoProviders[type]
    }

    public var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("ApiKey must be provided and cannot be empty.")
        }

        return apiKey
    }

    public init() {
        self.env = Environment.current
    }
}
