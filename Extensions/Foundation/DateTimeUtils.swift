//
//  DateTimeUtils.swift
//
//
//  Created by Yilei He on 14/04/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

// MARK: - Date & Duration -
extension TimeInterval {

    /**
     Example:
     ```
     25.0.localizedString//         "25 seconds"
     75.0.localizedString//         "1 minute"
     4789.12.localizedString//      "1 hour"
     12831231.0.localizedString//   "5 months"
     193912983.0.localizedString//  "6 years"
     ```
     */
    var formattedTimeDurationEstimation: String {
        struct _TimeUnit {
            let symbol: String
            let coeffcient: Double
        }
        let oneSecond: _TimeUnit = _TimeUnit(symbol: "second", coeffcient: 1)
        let oneMinute = _TimeUnit(symbol: "minute", coeffcient: 60)
        let oneHour = _TimeUnit(symbol: "hour", coeffcient: 3600)
        let oneDay = _TimeUnit(symbol: "day", coeffcient: 86400)
        let oneWeek = _TimeUnit(symbol: "week", coeffcient: 604800)
        let oneMonth = _TimeUnit(symbol: "month", coeffcient: 2592000)
        let oneYear = _TimeUnit(symbol: "year", coeffcient: 31449600)

        let units = [oneYear, oneMonth, oneWeek, oneDay, oneHour, oneMinute, oneSecond]

        for unit in units {
            if self > unit.coeffcient {
                let value = self / unit.coeffcient
                var symbol = unit.symbol
                if Int(value) > 1 {
                    symbol += "s"
                }
                return String(format: "%.0f", value) + " " + symbol
            }
        }
        return String(format: "%.0f", self) + " " + oneSecond.symbol
    }

}

// MARK: - Date & components -
extension Date {

    static var now: Date {
        return Date()
    }

    var isTimeInTheFuture: Bool {
        if #available(iOS 10.0, *) {
            return Date.now < self
        } else {
            return self.compare(Date()) == ComparisonResult.orderedDescending
        }
    }

    var isDayInTheFuture: Bool {
        if #available(iOS 10.0, *) {
            return Date.now.dateWithoutTimeComponents < self.dateWithoutTimeComponents
        } else {
            return  self.dateWithoutTimeComponents.compare(Date().dateWithoutTimeComponents) == .orderedDescending
        }
    }

    var isDayInThePast: Bool {
        if #available(iOS 10.0, *) {
            return Date.now.dateWithoutTimeComponents > self.dateWithoutTimeComponents
        } else {
            return  self.dateWithoutTimeComponents.compare(Date().dateWithoutTimeComponents) == .orderedAscending
        }
    }

    var isDayToday: Bool {
        if #available(iOS 8.0, *) {
            return Calendar.current.isDateInToday(self)
        } else {
            return  self.dateWithoutTimeComponents.compare(Date().dateWithoutTimeComponents) == .orderedSame
        }
    }

    /// 1000_000_000 nanosecond == 1 second
    var nanosecond: Int {
        return dateCompoments.nanosecond!
    }

    var second: Int {
        return dateCompoments.second!
    }

    var minute: Int {
        return dateCompoments.minute!
    }

    var hour: Int {
        return dateCompoments.hour!
    }

    var day: Int {
        return dateCompoments.day!
    }

    var weekOfMonth: Int {
        return dateCompoments.weekOfMonth!
    }

    var weekOfYear: Int {
        return dateCompoments.weekOfYear!
    }

    /// 1 == Sunday, 2 == Monday, 3 == Tuesday ... 7 == Saturday
    var weekDay: Int {
        return dateCompoments.weekday!
    }

    var month: Int {
        return dateCompoments.month!
    }

    var year: Int {
        return dateCompoments.year!
    }

    func isEarlierThanDate(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending
    }

    func isLaterThanDate(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending
    }

    func isSameDate(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedSame
    }

    var dateWithoutTimeComponents: Date {
        //let comps = Calendar.current.dateComponents([.day, .weekday,.weekOfMonth, .weekdayOrdinal, .weekOfYear, .month, .quarter ,.year], from: self)
        //return Calendar.current.date(from: comps)
        return Calendar.current.startOfDay(for: self)
    }

    private var dateCompoments: DateComponents {
        return Calendar.current.dateComponents([
            .nanosecond, .second, .minute, .hour,
            .day, .weekday, .weekOfMonth, .weekdayOrdinal, .weekOfYear,
            .month, .quarter, .year], from: self)
    }

}

// MARK: - Start & End of date period -
extension Date {
    func range(of component: Calendar.Component, in calendar: Calendar = Calendar.current) -> (start: Date, end: Date)? {
        if #available(iOS 10.0, *) {
            guard let dateInterval = calendar.dateInterval(of: component, for: self) else {
                return nil
            }
            return (dateInterval.start, dateInterval.end)
        } else {
            var start: NSDate?
            var interval: TimeInterval = 0
            if (calendar as NSCalendar).range(of: component.toNSCalendarUnit(), start: &start, interval: &interval, for: self) {
                return (start! as Date, (start! as Date) + interval)
            } else {
                return nil
            }
        }
    }
}

extension Calendar.Component {
    fileprivate func toNSCalendarUnit() -> NSCalendar.Unit {
        return NSCalendar.Unit(rawValue: 1 << UInt((hashValue + 1)))
    }
}

// MARK: - Iteration -
extension Date {

    private func next(components: Set<Calendar.Component>, direction: Calendar.SearchDirection = .forward) -> Date? {
        let components = Calendar.current.dateComponents(components, from: self)
        return Calendar.current.nextDate(after: self, matching: components, matchingPolicy: .previousTimePreservingSmallerComponents, direction: direction)
    }

    var nextDay: Date! {
        return next(components: [.hour, .minute, .second, .nanosecond])
    }

    var nextWeekThisWeekday: Date! {
        return next(components: [.weekday, .hour, .minute, .second, .nanosecond])
    }

    var nextMonthThisDay: Date! {
        return next(components: [.day, .hour, .minute, .second, .nanosecond])
    }

    /// Feb 29 becomes Feb 28 next year
    var nextYearThisDay: Date! {
        return next(components: [.month, .day, .hour, .minute, .second, .nanosecond])
    }

    var previousDay: Date! {
        return next(components: [.hour, .minute, .second, .nanosecond], direction: .backward)
    }

    var previousWeekThisWeekday: Date! {
        return next(components: [.weekday, .hour, .minute, .second, .nanosecond], direction: .backward)
    }

    var previousMonthThisDay: Date! {
        return next(components: [.day, .hour, .minute, .second, .nanosecond], direction: .backward)
    }

    /// Feb 29 becomes Feb 28 next year
    var previousYearThisDay: Date! {
        return next(components: [.month, .day, .hour, .minute, .second, .nanosecond], direction: .backward)
    }

}

// MARK: - Date <=> String -
extension Date {
    /**
     Converte the NSDate to String using formatter
     
     - parameter format: A string format
     
     - returns: Formatted String
     */
    func formattedString(format: String, AMSymbol: String = "AM", PMSymbol: String = "PM") -> String {
        struct staticObjects {
            static var dateFormatter = DateFormatter()
        }
        staticObjects.dateFormatter.amSymbol = AMSymbol
        staticObjects.dateFormatter.pmSymbol = PMSymbol
        staticObjects.dateFormatter.dateFormat = format
        return staticObjects.dateFormatter.string(from: self)
    }

    /**
     Convert a date string to a NSDate
     
     - parameter dateString: The date string
     - parameter format:     The string format
     
     - returns: An instance of NSDate
     */
    static func date(string: String, format: String, AMSymbol: String = "AM", PMSymbol: String = "PM") -> Date? {
        struct staticObjects {
            static var dateFormatter = DateFormatter()
        }
        staticObjects.dateFormatter.amSymbol = AMSymbol
        staticObjects.dateFormatter.pmSymbol = PMSymbol
        staticObjects.dateFormatter.dateFormat = format
        return staticObjects.dateFormatter.date(from: string)
    }

}

// MARK: - Date & milliseconds -
extension Date {

    /// Returns a Date initialized relative to 00:00:00 UTC on 1 January 1970 by a given number of milliseconds.
    init(millisecondsSince1970 milliseconds: Double) {
        self.init(timeIntervalSince1970: milliseconds / 1000)
    }

    init(millisecondsSinceNow milliseconds: Double) {
        self.init(timeIntervalSinceNow: milliseconds / 1000)
    }

    init(milliseconds: Double, since date: Date) {
        self.init(timeInterval: milliseconds / 1000, since: date)
    }

    init(millisecondsSinceReferenceDate milliseconds: Double) {
        self.init(timeIntervalSinceReferenceDate: milliseconds / 1000)
    }

    /// The milliseconds between the date object and 00:00:00 UTC on 1 January 1970.
    ///
    /// This property’s value is negative if the date object is earlier than 00:00:00 UTC on 1 January 1970.
    var millisecondsSince1970: Double {
        return timeIntervalSince1970 * 1000
    }

    /// The milliseconds between the date and the current date and time.
    ///
    /// If the date is earlier than the current date and time, this property’s value is negative.
    var millisecondsSinceNow: Double {
        return timeIntervalSinceNow * 1000
    }

    /// Returns the milliseconds between the receiver and another given date.
    ///
    /// - Parameter date: The date with which to compare the receiver.
    /// - Returns: The milliseconds between the receiver and the another parameter. If the receiver is earlier than date, the return value is negative.
    func millisecondsSince(_ date: Date) -> Double {
        return timeIntervalSince(date) * 1000
    }

    /// Returns the milliseconds between the date object and 00:00:00 UTC on 1 January 2001.
    ///
    /// This property’s value is negative if the date object is earlier than the system’s absolute reference date (00:00:00 UTC on 1 January 2001).
    var millisecondsSinceReferenceDate: Double {
        return timeIntervalSinceReferenceDate * 1000
    }
}

// MARK: - quick time interval -
extension Int {
    var second: TimeInterval {
        return TimeInterval(self)
    }

    var minute: TimeInterval {
        return 60 * self.second
    }

    var hour: TimeInterval {
        return 60 * self.minute
    }

    var day: TimeInterval {
        return 24 * self.hour
    }

    var week: TimeInterval {
        return 7 * self.day
    }

    var month: TimeInterval {
        return self.year / 12
    }

    var year: TimeInterval {
        return 365 * self.day
    }
}
