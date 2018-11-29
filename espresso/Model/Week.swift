//
//  Week.swift
//  espresso
//
//  Created by Jennifer on 11/20/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation

let userWeekDrinkLimit: Int = 5
let userWeekBudget: Double = 20

class Week {
    // Start date and end date are both inclusive
    var startDate: Date
    var endDate: Date
    
    var coffeeSpending: Double
    var coffeeCount: Int
    var bobaSpending: Double
    var bobaCount: Int
    var otherSpending: Double
    var otherCount: Int
    
    var totalSpending: Double
    var totalCount: Int
    var overBudget: Bool

    init(startDate: Date, endDate: Date, coffeeSpending: Double = 0, coffeeCount: Int = 0, bobaSpending: Double = 0, bobaCount: Int = 0, otherSpending: Double = 0, otherCount: Int = 0) {
        self.startDate = startDate
        self.endDate = endDate
        
        self.coffeeSpending = coffeeSpending
        self.coffeeCount = coffeeCount
        self.bobaSpending = bobaSpending
        self.bobaCount = bobaCount
        self.otherSpending = otherSpending
        self.otherCount = otherCount
        
        self.totalSpending = coffeeSpending + bobaSpending + otherSpending
        self.totalCount = coffeeCount + bobaCount + otherCount
        
        self.overBudget = false
        if (totalSpending >= userWeekBudget || totalCount >= userWeekDrinkLimit) {
            self.overBudget = true
        }
    }
    
    func update() {
        self.totalSpending = coffeeSpending + bobaSpending + otherSpending
        self.totalCount = coffeeCount + bobaCount + otherCount
        
        self.overBudget = false
        if (totalSpending >= userWeekBudget || totalCount >= userWeekDrinkLimit) {
            self.overBudget = true
        }
    }
    
    func getStartMonth() -> String {
        return self.startDate.getMonthName()
    }
    
    func getStartDay() -> String {
        return self.startDate.getDayName()
    }
    
    func getEndMonth() -> String {
        return self.endDate.getMonthName()
    }
    
    func getEndDay() -> String {
        return self.endDate.getDayName()
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
