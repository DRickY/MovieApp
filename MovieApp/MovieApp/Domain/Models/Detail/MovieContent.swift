//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct MovieContent {
    let id: Int
    let genre: String
    let country: String
    let title: String
    let overview: String
    let releaseDate: String
    let average: String
    let poster: URL?
    let backdrop: URL?
    let videoContent: VideoContent?
}

struct VideoContent {
    let id: String
    let name: String
    let key: String
    let site: VideoProvider
}
