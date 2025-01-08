//
//  TimestampMapper.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

enum FormatType {
    case string
    case date
}

struct DateMapper: Mapper {
    func map(from object: String) throws -> Date {
        let formatter = resolve(IDateTimeFormatter.self)

        guard let aDate = formatter.date(from: object, format: .date, timeZone: .current, locale: nil) else {
            throw AppError.unexpectedError
        }

        return aDate
    }
}

struct DateFormatConvertMapper: Mapper {
    let from: DateFormat
    let to: DateFormat

    func map(from object: String) throws -> String {
        guard !object.isEmpty else { return "" }

        let formatter = resolve(IDateTimeFormatter.self)

        guard let aFromDate = formatter.date(from: object, format: from, timeZone: .current, locale: nil) else {
            throw AppError.unexpectedError
        }

        return formatter.string(from: aFromDate, format: to, timeZone: .current, locale: nil)
    }
}
