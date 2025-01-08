//
//  PopularSearchBarDelegate.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine

final class PopularSearchBarDelegate: NSObject {
    private var _textDidChangePublisher = PassthroughSubject<String, Never>()

    public var textDidChange: AnyPublisher<String, Never> {
        return _textDidChangePublisher.eraseToAnyPublisher()
    }
}

extension PopularSearchBarDelegate: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)

        return true
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        _textDidChangePublisher.send(searchBar.text ?? "")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        _textDidChangePublisher.send("")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        _textDidChangePublisher.send(searchText)
    }
}
