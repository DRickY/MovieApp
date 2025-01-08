//
//  SearchControllerStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit

struct SearchControllerStyle: Decorator {
    let delegate: PopularSearchBarDelegate

    func apply(on object: PopularViewController) -> UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = delegate
        search.automaticallyShowsSearchResultsController = true
        search.automaticallyShowsCancelButton = true
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = L10n.searchPopular
        search.searchBar.searchTextField.clearButtonMode = .whileEditing
        return search
    }
}
