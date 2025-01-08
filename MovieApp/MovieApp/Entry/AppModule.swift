//
//  AppModule.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

struct AppModule: Module {
    init() {
        if Environment.current != .production {
            let console = ConsoleLogger(formatter: ConsoleFormatter(pattern: consoleLogPattern))

            log.addLoggers(
                console
            )
        }
    }

    func registerModule(using ioc: DependencyContainer) {
        ioc.register(for: IAppConfig.self, lifetime: .singleton) { _ in
            return AppConfig()
        }

        ioc.register(for: IConnectionMonitor.self, lifetime: .singleton) { _ in
            return ConnectionMonitor()
        }

        ioc.register(for: URLSessionHolder.self) { _ in
            #if DEBUG
            let configuration = URLSessionConfiguration.ephemeral
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            configuration.httpCookieStorage = nil
            configuration.httpShouldSetCookies = false
            configuration.urlCache = nil
            #else
            let configuration = URLSessionConfiguration.default
            #endif
            configuration.timeoutIntervalForRequest = 60
            configuration.timeoutIntervalForResource = 60

            return APIURLSession(configuration: configuration)
        }

        ioc.register(for: ClientExecutor.self) { _ in
            return ClientURLSessionExecutor()
        }

        ioc.register(for: IAPIClient.self) { _ in
            return APIClient()
        }

        ioc.register(for: IDateTimeFormatter.self) { _ in
            return DateTimeFormatter()
        }

        ioc.register(for: IGenreRepository.self, lifetime: .singleton) { _ in
            GenreRepository()
        }

        ioc.register(for: IGenreService.self, lifetime: .singleton) { _ in
            GenreService()
        }
    }

    func prepareModule(using ioc: DependencyContainer) {
        //
    }

    func finalizeModule(using ioc: DependencyContainer) {
        //
    }
}
