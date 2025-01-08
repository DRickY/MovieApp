//
//  PopularView.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

protocol PopularView: View, ProgressShowing, ErrorShowing, RefreshTrigger, LoadTriggering, PaginationTableViewShowing {
    var reloadContent: AnySubscriber<Bool, Never> { get }
    var disable: AnySubscriber<Bool, Never> { get }
    var sortActionTrigger: AnyPublisher<MovieSortingOption, Never> { get }
    var loadNextTrigger: AnyPublisher<Void, Never> { get }
    var searchTextTrigger: AnyPublisher<String, Never> { get }
    var didSelectRowTrigger: AnyPublisher<IndexPath, Never> { get }
}
