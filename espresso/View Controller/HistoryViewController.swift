//
//  HistoryViewController.swift
//  espresso
//
//  Created by Jennifer on 11/14/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Firebase
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    // Past 12 months
    var sectionMonths: [Month] = []
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        // self.tableView!.tableFooterView = UIView()
        
        // Initialize past 12 months
        var currDate: Date = Date()
        var prevDate: Date
        for _ in 1...12 {
            prevDate = Calendar.current.date(byAdding: .month, value: -1, to: currDate)!
            let month = Month(month: prevDate.getMonthName(), year: prevDate.getYearName())
            sectionMonths.append(month)
            currDate = prevDate
        }
        
        // Get all transactions from Firebase
        ref.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String:Any]
            
            if let transactions = values {
                var allTransactions: [Transaction] = []
                for (_, tValue) in transactions {
                    let info = tValue as! [String:Any]
                    let t = Transaction(date: info["date"] as! String, drink: info["drink"] as! String, price: info["price"] as! Double)
                    allTransactions.append(t)
                }
                
                for t in allTransactions {
                    for m in self.sectionMonths {
                        if m.month == t.date.getMonthName() && m.year == t.date.getYearName() {
                            switch t.drink {
                            case "coffee":
                                m.coffeeCount += 1
                                m.coffeeSpending += t.price
                            case "boba":
                                m.bobaCount += 1
                                m.bobaSpending += t.price
                            case "other":
                                m.otherCount += 1
                                m.otherSpending += t.price
                            default:
                                print("error, transaction did not have valid drink")
                            }
                            m.update()
                            break
                        }
                    }
                }
                
//                // TEMP - COMMENT OUT
//                for m in self.sectionMonths {
//                    print(m.month, m.year)
//                    print(m.totalSpending)
//                    print(m.totalCount)
//                    print(m.overBudget)
//                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionMonths.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(self.sectionMonths[section].month)
        return self.sectionMonths[section].month
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        let m = self.sectionMonths[indexPath.section] as Month
        cell.dateLabel?.text = m.month
        cell.spendingLabel?.text = String(m.totalSpending)
        cell.countLabel?.text = String(m.totalCount)
        print(m.month)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAtindexPath: IndexPath) {
        tableView.deselectRow(at: didDeselectRowAtindexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
