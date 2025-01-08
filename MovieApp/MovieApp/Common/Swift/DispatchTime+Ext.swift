//
//  w.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

extension DispatchTime {
    func profile() -> TimeInterval {
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - self.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1000000000

        return timeInterval
    }
}
