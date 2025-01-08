//
//  Optional+Ext.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public extension Optional {
    var isLet: Bool {
        return self != nil
    }
}

public extension Optional {
    func getValue(_ callback: (Wrapped) -> Void) {
        _ = map { callback($0) }
    }
}

extension Optional where Wrapped == String {
    var isEmpty: Bool {
        if let value = self {
            return value.isEmpty
        } else {
            return true
        }
    }
}
