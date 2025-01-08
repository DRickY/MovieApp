//
//  DefaultQuery.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

extension Query where Self == BaseQuery {
    static var defaultQuery: Query {
        let config = resolve(IAppConfig.self)

        return BaseQuery(params: [
            "language": config.locale
        ])
    }
}
