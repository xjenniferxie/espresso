//
//  HomeViewController.swift
//  espresso
//
//  Created by Jennifer on 11/14/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    // Firebase
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    // Outlets to labels and views
    @IBOutlet weak var drinkNumLabel: UILabel!
    @IBOutlet weak var drinkTotalLabel: UILabel!
    @IBOutlet weak var totalBar: UIView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var moneySpentLabel: UILabel!
    @IBOutlet weak var moneyLeftLabel: UILabel!
    
    var currWeek: Week = Week(startDate: Date(), endDate: Date())
    
    // Add drink button pressed
    @IBAction func addPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToAddDrink", sender: sender)
    }
    
    // Unwind from Add Drink to Home
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currWeekFromTransactions()
        
        print(self.currWeek.coffeeSpending)
        print(self.currWeek.coffeeCount)
        print(self.currWeek.bobaSpending)
        print(self.currWeek.bobaCount)
        print(self.currWeek.otherSpending)
        print(self.currWeek.otherCount)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currWeekFromTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currWeekFromTransactions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currWeekFromTransactions() {
        let currMonth = FirstSundayAndNumWeeksInMonth(date: Date())
        let startDate = currMonth.0
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
        currWeek = Week(startDate: startDate, endDate: endDate)
        
        // Get all transactions from Firebase
        ref.child("Users").child((user?.uid)!).child("Transactions").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String:Any]
            
            if let transactions = values {
                var allTransactions: [Transaction] = []
                for (_, tValue) in transactions {
                    let info = tValue as! [String:Any]
                    let t = Transaction(date: info["date"] as! String, drink: info["drink"] as! String, price: info["price"] as! Double)
                    allTransactions.append(t)
                }
                
                // Update info for each week
                for t in allTransactions {
                    if t.date >= self.currWeek.startDate && t.date <= self.currWeek.endDate {
                        switch t.drink {
                        case "coffee":
                            self.currWeek.coffeeCount += 1
                            self.currWeek.coffeeSpending += t.price
                        case "boba":
                            self.currWeek.bobaCount += 1
                            self.currWeek.bobaSpending += t.price
                        case "other":
                            self.currWeek.otherCount += 1
                            self.currWeek.otherSpending += t.price
                        default:                                print("error, transaction did not have valid drink")
                        }
                        self.currWeek.update()
                        break
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        drinkTotalLabel.text = "\(userWeekDrinkLimit) drinks"
        drinkNumLabel.text = "\(self.currWeek.totalCount)/"
        moneySpentLabel.text = "\(formatMoney(amount: self.currWeek.totalSpending)) spent"
        if self.currWeek.totalSpending > userWeekBudget {
            moneyLeftLabel.text = "$0 left"
        } else {
            moneyLeftLabel.text = "$\(Int(userWeekBudget - self.currWeek.totalSpending)) left"
        }
        
        // let fraction = Double(self.currWeek.totalCount) / Double(userWeekDrinkLimit)
        let fraction = Double(3/5)
        if self.currWeek.totalCount > userWeekDrinkLimit {
            progressBar.frame.size.width = totalBar.frame.size.width
        } else {
            progressBar.frame.size.width = CGFloat(fraction * Double(totalBar.frame.size.width))
        }

        if self.currWeek.overBudget {
            progressBar.backgroundColor = UIColor(named: "Red")
        } else {
            progressBar.backgroundColor = UIColor(named: "Green")
        }
        
    }
}


