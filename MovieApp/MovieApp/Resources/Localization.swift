//
//  Localization.swift
//  MovieApp
//
//  Created by Dmytro on 07.01.2025.
//

import Foundation

public extension L10n {
    static var unknown: String {
        localize(key: "unknown_key")
    }

    static var back: String {
        return localize(key: "back_key")
    }

    static var connectionLost: String {
        return localize(key: "connection_lost_key")
    }

    static var offine: String {
        return localize(key: "you_are_offline_key")
    }

    static var wificellular: String {
        return localize(key: "wifi_cellular_key")
    }

    static var popularMovies: String {
        return localize(key: "popular_movies_key")
    }

    static var closeButton: String {
        return localize(key: "close_button_key")
    }

    static var unexpectedError: String {
        return localize(key: "unexpected_error")
    }

    static var searchPopular: String {
        return localize(key: "search_popular_key")
    }

    static var pullRefresh: String {
        return localize(key: "pull_refresh_key")
    }

    // keys

    static var popularityDesc: String {
        return localize(key: "popularity_desc_key")
    }

    static var popularityAsc: String {
        return localize(key: "popularity_asc_key")
    }

    static var revenueAsc: String {
        return localize(key: "revenue_asc_key")
    }

    static var revenueDesc: String {
        return localize(key: "revenue_desc_key")
    }

    static var releaseDateAsc: String {
        return localize(key: "primary_release_date_asc_key")
    }

    static var releaseDateDesc: String {
        return localize(key: "primary_release_date_desc_key")
    }

    static var titleAsc: String {
        return localize(key: "title_asc_key")
    }

    static var titleDesc: String {
        return localize(key: "title_desc_key")
    }

    static var voteAverageAsc: String {
        return localize(key: "vote_average_asc_key")
    }

    static var voteAverageDesc: String {
        return localize(key: "vote_average_desc_key")
    }

    static var voteCountAsc: String {
        return localize(key: "vote_count_asc_key")
    }

    static var voteCountDesc: String {
        return localize(key: "vote_count_desc_key")
    }

    static var sortOptions: String {
        return localize(key: "sort_options_key")
    }

    static var rating: String {
        return localize(key: "rating_key")
    }

    static var Ok: String {
        return localize(key: "ok_key")
    }

    static var photoUnavailable: String {
        return localize(key: "photo_unavailable_key")
    }

    static var photoUnavailableInfo: String {
        return localize(key: "photo_unavailable_info_key")
    }
}

public enum L10n {
    fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
    fileprivate static let hostingBundle = Bundle(for: Self.Class.self)

    private static func localize(key: String, preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
            return NSLocalizedString(key, bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
            return key
        }

        return NSLocalizedString(key, bundle: bundle, comment: "")
    }

    fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
        var languages = preferredLanguages
            .map { Locale(identifier: $0) }
            .prefix(1)
            .flatMap { locale -> [String] in
                if hostingBundle.localizations.contains(locale.identifier) {
                    if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
                        return [locale.identifier, language]
                    } else {
                        return [locale.identifier]
                    }
                } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
                    return [language]
                } else {
                    return []
                }
            }

        if languages.isEmpty {
            if let developmentLocalization = hostingBundle.developmentLocalization {
                languages = [developmentLocalization]
            }
        } else {
            languages.insert("Base", at: 1)

            if let developmentLocalization = hostingBundle.developmentLocalization {
                languages.append(developmentLocalization)
            }
        }

        for language in languages {
            if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
               let lbundle = Bundle(url: lproj) {
                let strings = lbundle.url(forResource: tableName, withExtension: "strings")
                let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

                if strings != nil || stringsdict != nil {
                    return (Locale(identifier: language), lbundle)
                }
            }
        }

        let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
        let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

        if strings != nil || stringsdict != nil {
            return (applicationLocale, hostingBundle)
        }

        return nil
    }

    fileprivate class Class {}
}
