//
//  Transaction.swift
//  espresso
//
//  Created by Jennifer on 11/20/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation

class Transaction {
    var date: Date
    var drink: String
    var price: Double
    
    init(date: String, drink: String, price: Double) {
        self.drink = drink
        self.price = price
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyyy"
        self.date = dateFormatter.date(from: date)!
    }
}
