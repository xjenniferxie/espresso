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
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        // self.historyTableView!.tableFooterView = UIView()
        
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
                
                // TEMP - COMMENT OUT
//                for m in self.sectionMonths {
//                    print(m.month, m.year)
//                    print(m.totalSpending)
//                    print(m.totalCount)
//                    print(m.overBudget)
//                    print(m.coffeeSpending)
//                    print(m.coffeeCount)
//                    print(m.bobaSpending)
//                    print(m.bobaCount)
//                    print(m.otherSpending)
//                    print(m.otherCount)
//                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionMonths.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionMonths[section].month
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(named: "Green")
        header.textLabel?.textColor = UIColor(named: "White")
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(HistoryViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        let m = self.sectionMonths[indexPath.section]
        cell.coffeeSpendingLabel?.text = String(m.coffeeSpending)
        cell.coffeeCountLabel?.text = String(m.coffeeCount)
        cell.bobaSpendingLabel?.text = String(m.bobaSpending)
        cell.bobaCountLabel?.text = String(m.bobaCount)
        cell.otherSpendingLabel?.text = String(m.otherSpending)
        cell.otherCountLabel?.text = String(m.otherCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section = headerView.tag
        
        print("section header touched", section)
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section)
            } else {
                tableViewCollapeSection(self.expandedSectionHeaderNumber)
                tableViewExpandSection(section)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int) {
        self.expandedSectionHeaderNumber = -1;
        
        var indexesPath = [IndexPath]()
        let index = IndexPath(row: 0, section: section)
        indexesPath.append(index)
        
        self.historyTableView!.beginUpdates()
        self.historyTableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
        self.historyTableView!.endUpdates()
    }
    
    func tableViewExpandSection(_ section: Int) {
        var indexesPath = [IndexPath]()
        let index = IndexPath(row: 0, section: section)
        indexesPath.append(index)
        
        self.expandedSectionHeaderNumber = section
        
        self.historyTableView!.beginUpdates()
        self.historyTableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
        self.historyTableView!.endUpdates()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
