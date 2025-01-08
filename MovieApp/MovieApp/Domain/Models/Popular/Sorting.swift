//
//  Sorting.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

enum MovieSortingOption: CaseIterable, CustomStringConvertible {
    case popularityDesc // default
    case popularityAsc
    case revenueAsc
    case revenueDesc
    case primaryReleaseDateAsc
    case primaryReleaseDateDesc
    case titleAsc
    case titleDesc
    case voteAverageAsc
    case voteAverageDesc
    case voteCountAsc
    case voteCountDesc

    var key: String {
        switch self {
        case .popularityDesc: "popularity.desc"
        case .popularityAsc: "popularity.asc"
        case .revenueAsc: "revenue.asc"
        case .revenueDesc: "revenue.desc"
        case .primaryReleaseDateAsc: "primary_release_date.asc"
        case .primaryReleaseDateDesc: "primary_release_date.desc"
        case .titleAsc: "title.asc"
        case .titleDesc: "title.desc"
        case .voteAverageAsc: "vote_average.asc"
        case .voteAverageDesc: "vote_average.desc"
        case .voteCountAsc: "vote_count.asc"
        case .voteCountDesc: "vote_count.desc"
        }
    }

    var description: String {
        switch self {
        case .popularityDesc: L10n.popularityDesc
        case .popularityAsc: L10n.popularityAsc
        case .revenueAsc: L10n.revenueAsc
        case .revenueDesc: L10n.revenueDesc
        case .primaryReleaseDateAsc: L10n.releaseDateAsc
        case .primaryReleaseDateDesc: L10n.releaseDateDesc
        case .titleAsc: L10n.titleAsc
        case .titleDesc: L10n.titleDesc
        case .voteAverageAsc: L10n.voteAverageAsc
        case .voteAverageDesc: L10n.voteAverageDesc
        case .voteCountAsc: L10n.voteCountAsc
        case .voteCountDesc: L10n.voteCountDesc
        }
    }
}
