//
//  APIPath.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

enum APIPath: RouteType {
    case popular
    case searchMovie
    case genres
    case movie(id: Int)

    var path: String {
        switch self {
        case .popular:
            return "3/discover/movie"
        case .searchMovie:
            return "3/search/movie"
        case .genres:
            return "3/genre/movie/list"
        case .movie(let id):
            return "3/movie/\(id)"
        }
    }

    func route() throws -> String {
        let config = resolve(IAppConfig.self)

        guard let url = URL(string: "/\(path)", relativeTo: URL(string: config.baseURL)) else {
            throw AppError.unexpectedError
        }

        return url.absoluteString
    }
}
