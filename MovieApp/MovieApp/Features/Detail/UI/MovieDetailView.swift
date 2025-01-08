//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

protocol MovieDetailView: View, LoadTriggering, ProgressShowing, ErrorShowing {
    var posterImageTapTrigger: AnyPublisher<Void, Never> { get }

    var trailerTapTrigger: AnyPublisher<Void, Never> { get }

    var backTapTrigger: AnyPublisher<Void, Never> { get }

    var content: AnySubscriber<MovieContent, Never> { get }

    var disable: AnySubscriber<Bool, Never> { get }
}
