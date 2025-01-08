//
//  ConnectionMonitorStatus.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

enum ConnectionMonitorStatus: Equatable, CustomStringConvertible {
    enum ConnectionType: CustomStringConvertible {
        case ethernetOrWiFi
        case cellular

        var description: String {
            switch self {
            case .ethernetOrWiFi:
                return "Ethernet or wifi connection"
            case .cellular:
                return "Cellular connection"
            }
        }
    }

    case unknown
    case notReachable
    case reachable(ConnectionType)

    var description: String {
        switch self {
        case .unknown:
            return "Unknown state"
        case .notReachable:
            return "Network is not reachable"
        case .reachable(let type):
            return type.description
        }
    }

    var isReachable: Bool {
        switch self {
        case .unknown, .reachable:
            return true
        default:
            return false
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown):
            return true
        case (.notReachable, .notReachable):
            return true
        case (.reachable, .reachable):
            return true
        default:
            return false
        }
    }
}
