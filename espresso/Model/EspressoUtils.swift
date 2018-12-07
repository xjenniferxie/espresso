//
//  EspressoUtils.swift
//  espresso
//
//  Created by Jennifer on 12/6/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation

func formatMoney(amount: Double) -> String {
    let price: Int = Int(amount * 100)
    if price < 10 {
        return "$0.0\(price)"
    } else if price < 100 {
        return "$0.\(price)"
    } else {
        let cents = price % 100
        if cents < 10 {
            return "$\(Int(price / 100)).0\(cents)"
        } else {
            return "$\(Int(price / 100)).\(cents)"
        }
    }
}

func FirstSundayAndNumWeeksInMonth(date: Date) -> (Date, Int?) {
    var calendar = Calendar(identifier: .gregorian)
    calendar.firstWeekday = 1 // 1 == Sunday
    
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    
    // First Sunday in month:
    var comps = DateComponents(year: year, month: month,
                               weekday: calendar.firstWeekday, weekdayOrdinal: 1)
    guard let first = calendar.date(from: comps)  else {
        return (Date(), nil)
    }
    
    // Last Sunday in month:
    comps.weekdayOrdinal = -1
    guard let last = calendar.date(from: comps)  else {
        return (Date(), nil)
    }
    
    // Difference in weeks:
    let weeks = calendar.dateComponents([.weekOfMonth], from: first, to: last)
    return (first, weeks.weekOfMonth! + 1)
}

extension Date {
    func getDayName() -> String {
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "dd"
        let strDay = dayDateFormatter.string(from: self)
        return strDay
    }
    
    func getMonthName() -> String {
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MMM"
        let strMonth = monthDateFormatter.string(from: self)
        return strMonth
    }
    
    func getYearName() -> String {
        let yearDateFormatter = DateFormatter()
        yearDateFormatter.dateFormat = "yyyy"
        let strYear = yearDateFormatter.string(from: self)
        return strYear
    }
}
