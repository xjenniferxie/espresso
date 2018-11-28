//
//  Month.swift
//  espresso
//
//  Created by Jennifer on 11/20/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation

let userDrinkLimit: Int = 5
let userBudget: Double = 20

class Month {
    var month: String
    var year: String
    var coffeeSpending: Double
    var coffeeCount: Int
    var bobaSpending: Double
    var bobaCount: Int
    var otherSpending: Double
    var otherCount: Int
    
    var totalSpending: Double
    var totalCount: Int
    var overBudget: Bool
    
    init(month: String, year: String, coffeeSpending: Double = 0, coffeeCount: Int = 0, bobaSpending: Double = 0, bobaCount: Int = 0, otherSpending: Double = 0, otherCount: Int = 0) {
        self.month = month
        self.year = year
        self.coffeeSpending = coffeeSpending
        self.coffeeCount = coffeeCount
        self.bobaSpending = bobaSpending
        self.bobaCount = bobaCount
        self.otherSpending = otherSpending
        self.otherCount = otherCount
        
        self.totalSpending = coffeeSpending + bobaSpending + otherSpending
        self.totalCount = coffeeCount + bobaCount + otherCount
        
        self.overBudget = false
        if (totalSpending >= userBudget || totalCount >= userDrinkLimit) {
            self.overBudget = true
        }
    }
    
    func update() {
        self.totalSpending = coffeeSpending + bobaSpending + otherSpending
        self.totalCount = coffeeCount + bobaCount + otherCount
        
        self.overBudget = false
        if (totalSpending >= userBudget || totalCount >= userDrinkLimit) {
            self.overBudget = true
        }
    }
    
}


extension Date {
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


