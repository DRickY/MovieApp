//
//  DateTimeFormatter.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation

protocol IDateTimeFormatter {
    func string(from date: Date, format: String, timeZone: TimeZone, locale: Locale?) -> String

    func date(from string: String, format: String, timeZone: TimeZone, locale: Locale?) -> Date?

    func date(from string: String, format: DateFormat, timeZone: TimeZone, locale: Locale?) -> Date?

    func string(from date: Date, format: DateFormat, timeZone: TimeZone, locale: Locale?) -> String
}

public enum DateFormat: String {
    case date = "yyyy-MM-dd"
    case monthYear = "MMM, yyyy"
}

public final class DateTimeFormatter: IDateTimeFormatter {
    private var formatters = [String: DateFormatter]()

    private func formatter(for dateFormat: String, timeZone: TimeZone = .current, locale: Locale? = .current) -> DateFormatter {
        if let formatter = formatters[dateFormat] {
            return formatter
        }

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = locale ?? Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatters[dateFormat] = formatter

        return formatter
    }

    public func string(from date: Date, format: String, timeZone: TimeZone = .current, locale: Locale? = .current) -> String {
        let formatter = self.formatter(for: format, timeZone: timeZone, locale: locale)
        return formatter.string(from: date)
    }

    public func date(from string: String, format: String, timeZone: TimeZone = .current, locale: Locale? = .current) -> Date? {
        let formatter = self.formatter(for: format, timeZone: timeZone, locale: locale)
        return formatter.date(from: string)
    }

    public func date(from string: String, format: DateFormat, timeZone: TimeZone = .current, locale: Locale? = .current) -> Date? {
        return date(from: string, format: format.rawValue, timeZone: timeZone, locale: locale)
    }

    public func string(from date: Date, format: DateFormat, timeZone: TimeZone = .current, locale: Locale? = .current) -> String {
        return string(from: date, format: format.rawValue, timeZone: timeZone, locale: locale)
    }
}
