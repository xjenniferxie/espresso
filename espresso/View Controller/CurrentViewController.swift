//
//  CurrentViewController.swift
//  espresso
//
//  Created by Jennifer on 11/14/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CurrentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Firebase
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var currentTableView: UITableView!
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionWeeks: [Week] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTableView.delegate = self
        currentTableView.dataSource = self
        
        // Initialize weeks
        let currMonth = FirstSundayAndNumWeeksInMonth(date: Date())
        let numWeeks = currMonth.1!
        var startDate = currMonth.0
        var endDate: Date
        for _ in 1...numWeeks {
            endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
            let week = Week(startDate: startDate, endDate: endDate)
            sectionWeeks.append(week)
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
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

                // Update info for each week
                for t in allTransactions {
                    for w in self.sectionWeeks {
                        if t.date >= w.startDate && t.date <= w.endDate {
                            switch t.drink {
                            case "coffee":
                                w.coffeeCount += 1
                                w.coffeeSpending += t.price
                            case "boba":
                                w.bobaCount += 1
                                w.bobaSpending += t.price
                            case "other":
                                w.otherCount += 1
                                w.otherSpending += t.price
                            default:
                                print("error, transaction did not have valid drink")
                            }
                            w.update()
                            break
                        }
                    }
                }
                
                // TESTING
                for w in self.sectionWeeks {
                    print("")
                    print(w.getStartMonth(), w.getStartDay())
                    print(w.getEndMonth(), w.getEndDay())
                    print(w.totalSpending)
                    print(w.totalCount)
                    print(w.coffeeSpending)
                    print(w.coffeeCount)
                    print(w.bobaSpending)
                    print(w.bobaCount)
                    print(w.bobaSpending)
                    print(w.bobaCount)
                }

            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    // TABLEVIEW METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionWeeks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let w = self.sectionWeeks[section]
        
        print("title-testing-----")
        print(w.getStartMonth(), w.getStartDay())
        print(w.getEndMonth(), w.getEndDay())
        print(w.totalSpending)
        print(w.totalCount)
        print(w.coffeeSpending)
        print(w.coffeeCount)
        print(w.bobaSpending)
        print(w.bobaCount)
        print(w.bobaSpending)
        print(w.bobaCount)
        
        if w.getStartMonth() == w.getEndMonth() {
            return "\(w.getStartMonth()) \(w.getStartDay()) - \(w.getEndDay())     $\(w.totalSpending)     \(w.totalCount)"
        } else {
            return "\(w.getStartMonth()) \(w.getStartDay()) - \(w.getEndMonth()) \(w.getEndDay())     $\(w.totalSpending)     \(w.totalCount)"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(named: "LightMint")
        header.textLabel?.textColor = UIColor(named: "Black")

        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(HistoryViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath) as! WeekCell
        let w = self.sectionWeeks[indexPath.section]
        cell.coffeeSpendingLabel?.text = String(w.coffeeSpending)
        cell.coffeeCountLabel?.text = String(w.coffeeCount)
        cell.bobaSpendingLabel?.text = String(w.bobaSpending)
        cell.bobaCountLabel?.text = String(w.bobaCount)
        cell.otherSpendingLabel?.text = String(w.otherSpending)
        cell.otherCountLabel?.text = String(w.otherCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Behavior when section header touched
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section = headerView.tag

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

        self.currentTableView!.beginUpdates()
        self.currentTableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
        self.currentTableView!.endUpdates()
    }

    func tableViewExpandSection(_ section: Int) {
        var indexesPath = [IndexPath]()
        let index = IndexPath(row: 0, section: section)
        indexesPath.append(index)

        self.expandedSectionHeaderNumber = section

        self.currentTableView!.beginUpdates()
        self.currentTableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
        self.currentTableView!.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80;
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
