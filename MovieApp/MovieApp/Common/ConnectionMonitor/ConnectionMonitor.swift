//
//  ConnectionMonitor.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import Connectivity
import Combine

private let tag = LogTag("ConnectionMonitor")

protocol IConnectionMonitor {
    var connectionStatus: ConnectionMonitorStatus { get }
    var onConnectionStatus: AnyPublisher<ConnectionMonitorStatus, Never> { get }

    func checkConnectivity()
}

final class ConnectionMonitor: IConnectionMonitor {
    private(set) lazy var onConnectionStatus: AnyPublisher<ConnectionMonitorStatus, Never> = _onStatusConnectionChanged
        .removeDuplicates()
        .eraseToAnyPublisher()

    private let manager = Connectivity.init(configuration: .init())

    private let _onStatusConnectionChanged = SingleValueSubject<ConnectionMonitorStatus, Never>()

    private(set) var connectionStatus: ConnectionMonitorStatus = .unknown {
        didSet {
            log.info(tag, "Connection Status \(self.connectionStatus.description)")
            _onStatusConnectionChanged.send(connectionStatus)
        }
    }

    init() {
        _onStatusConnectionChanged.send(.unknown)
        manager.checkWhenApplicationDidBecomeActive = true
        manager.validationMode = .custom
        manager.responseValidator = ConnectionValidator()
        manager.framework = .network

        let connectivityCallback: (Connectivity) -> Void = { [weak self] connectivity in
            guard let this = self else { return }
            this.connectionStatus = this.convertStatus(connectivity.status)
        }

        manager.whenConnected = connectivityCallback
        manager.whenDisconnected = connectivityCallback

        manager.startNotifier()
    }

    func checkConnectivity() {
        manager.checkConnectivity()
    }

    private func convertStatus(_ connectivityStatus: ConnectivityStatus) -> ConnectionMonitorStatus {
        switch connectivityStatus {
        case .determining:
            return .unknown
        case .connected:
            return .reachable(.ethernetOrWiFi)
        case .connectedViaWiFi:
            return .reachable(.ethernetOrWiFi)
        case .connectedViaCellular:
            return .reachable(.cellular)

        default:
            return .notReachable
        }
    }

    private class ConnectionValidator: ConnectivityResponseValidator {
        func isResponseValid(urlRequest: URLRequest, response: URLResponse?, data: Data?) -> Bool {
            guard let response = response as? HTTPURLResponse else { return false }

            return (200..<500).contains(response.statusCode)
        }
    }
}
