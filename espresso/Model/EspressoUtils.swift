//
//  EspressoUtils.swift
//  espresso
//
//  Created by Jennifer on 12/6/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation

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
