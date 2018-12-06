//
//  Month.swift
//  espresso
//
//  Created by Jennifer on 11/20/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation

let userMonthDrinkLimit: Int = 20
let userMonthBudget: Double = 80

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
        if (totalSpending >= userMonthBudget || totalCount >= userMonthDrinkLimit) {
            self.overBudget = true
        }
    }
    
    init(info: [String:Any]) {
        self.month = info["Month"] as! String
        self.year = info["year"] as! String
        self.coffeeSpending = info["coffeeSpending"] as! Double
        self.coffeeCount = info["coffeeCount"] as! Int
        self.bobaSpending = info["bobaSpending"] as! Double
        self.bobaCount = info["bobaCount"] as! Int
        self.otherSpending = info["otherSpending"] as! Double
        self.otherCount = info["otherCount"] as! Int
        
        self.totalSpending = coffeeSpending + bobaSpending + otherSpending
        self.totalCount = coffeeCount + bobaCount + otherCount
        
        self.overBudget = false
        if (totalSpending >= userMonthBudget || totalCount >= userMonthDrinkLimit) {
            self.overBudget = true
        }
    }
    
    // Run update after you've changed any of the 
    func update() {
        self.totalSpending = coffeeSpending + bobaSpending + otherSpending
        self.totalCount = coffeeCount + bobaCount + otherCount
        
        self.overBudget = false
        if (totalSpending >= userMonthBudget || totalCount >= userMonthDrinkLimit) {
            self.overBudget = true
        }
    }
    
    func getInfo() -> [String:Any] {
        let info: [String:Any] = ["month": self.month,
                                  "year": self.year,
                                  "coffeeSpending": self.coffeeSpending,
                                  "coffeeCount": self.coffeeCount,
                                  "bobaSpending": self.bobaSpending,
                                  "bobaCount": self.bobaCount,
                                  "otherSpending": self.otherSpending,
                                  "otherCount": self.otherCount]
        return info
    }
    
}




