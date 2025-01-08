//
//  Environment.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

public enum Environment: String {
    case development, sandbox, production

    private static let isSandbox = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    public static var current: Environment {
        if isDebug {
            return .development
        } else if isSandbox {
            return .sandbox
        } else {
            return .production
        }
    }
}
