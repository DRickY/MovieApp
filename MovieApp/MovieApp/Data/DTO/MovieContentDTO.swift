//
//  MovieContentDTO.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

// Note: These settings are optional because it's unclear which values might be null when the API provides data.
struct MovieContentDTO: Decodable {
    let id: Int
    let backdropPath: String?
    let posterPath: String?
    let originalTitle: String?
    let title: String?
    let overview: String?
    let originCountry: [String]?
    let productionCountries: [ProductionCountryDTO]?
    let genres: [GenreDTO]?
    let releaseDate: String?
    let voteAverage: Double?
    let videos: VideoResultDTO?
}

struct ProductionCountryDTO: Decodable {
    let iso_3166_1: String?
    let name: String?
}

struct VideoResultDTO: Decodable {
    let results: [MovieContentVideoDTO]
}

struct MovieContentVideoDTO: Decodable {
    let id: String
    let key: String
    let name: String
    let publishedAt: String
    let size: Int
    let official: Bool
    let type: VideoType
    let site: SiteType
}

enum VideoType: Decodable, Hashable {
    case behindTheScenes
    case featurette
    case clip
    case teaser
    case trailer
    case custom(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "Behind the Scenes":
            self = .behindTheScenes
        case "Clip":
            self = .clip
        case "Featurette":
            self = .featurette
        case "Teaser":
            self = .teaser
        case "Trailer":
            self = .trailer
        default:
            self = .custom(rawValue)
        }
    }
}

enum SiteType: Decodable {
    case youtube
    case custom(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "YouTube":
            self = .youtube
        default:
            self = .custom(rawValue)
        }
    }
}

extension SiteType: CustomStringConvertible {
    var description: String {
        switch self {
        case .youtube:
            return "YouTube"
        case .custom(let string):
            return string
        }
    }
}

struct MovieContentMapper: Mapper {
    func map(from object: MovieContentDTO) throws -> MovieContent {
        let dateMapper = DateFormatConvertMapper(from: .date, to: .monthYear)

        let imageMapper = ImageURLMapper(imageSize: .large)

        let genres = object.genres ?? []

        let posterURL = object.posterPath.flatMap {
            try? imageMapper.map(from: $0)
        }

        let backdropURL = object.backdropPath.flatMap {
            try? imageMapper.map(from: $0)
        }

        let title = (object.title.isEmpty ? object.originalTitle : object.title) ?? L10n.unknown

        let average = object.voteAverage.map { String(format: "%.2f", $0) } ?? "0.0"

        let productionCountries = object.productionCountries ?? []

        let countrySymbol = object.originCountry?.first ?? productionCountries.first?.iso_3166_1 ?? L10n.unknown

        let date = try object.releaseDate.flatMap {
            try dateMapper.map(from: $0)
        } ?? ""

        let overview = object.overview ?? L10n.unknown

        let videos = object.videos?.results
            .filter { $0.official && $0.type == .trailer }
            .map {
                VideoContent(id: $0.id, name: $0.name, key: $0.key, site: $0.site.map())
            }

        return MovieContent(id: object.id,
                            genre: genres.genresText,
                            country: countrySymbol,
                            title: title,
                            overview: overview,
                            releaseDate: date,
                            average: average,
                            poster: posterURL,
                            backdrop: backdropURL,
                            videoContent: videos?.first)
    }
}

extension SiteType {
    func map() -> VideoProvider {
        switch self {
        case .youtube:
            return .youtube
        case .custom(let string):
            return .custom(string)
        }
    }
}
