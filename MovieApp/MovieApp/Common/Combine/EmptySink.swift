//
//  EmptySink.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Combine

extension Publisher {
    func sink() -> AnyCancellable {
        return self.sink { _ in } receiveValue: { _ in }
    }
}
