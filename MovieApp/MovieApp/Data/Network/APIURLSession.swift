//
//  APIURLSession.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

protocol URLSessionHolder {
    var session: URLSession { get }
}

final class APIURLSession: URLSessionHolder {
    let session: URLSession

    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
}
