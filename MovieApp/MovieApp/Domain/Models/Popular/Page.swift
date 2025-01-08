//
//  Page.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct Page<T> {
    let content: [T]
    let page: Int
    let totalPages: Int
    let totalResults: Int
}

extension Page {
    static var empty: Page<T> {
        return .init(content: [], page: 0, totalPages: 0, totalResults: 0)
    }
}

extension Page {
    subscript(_ indexPath: IndexPath) -> T {
        self.content[indexPath.row]
    }
}
