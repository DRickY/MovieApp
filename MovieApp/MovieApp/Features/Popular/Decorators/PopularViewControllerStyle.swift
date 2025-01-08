//
//  PopularViewControllerStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct PopularViewControllerStyle: Decorator {
    let searchBarDelegate: PopularSearchBarDelegate

    func apply(on object: PopularViewController) {
        object.view.backgroundColor = .white
        object.navigationItem.searchController = object.apply(SearchControllerStyle(delegate: searchBarDelegate))
        object.navigationItem.hidesSearchBarWhenScrolling = true
        object.definesPresentationContext = true
    }
}
