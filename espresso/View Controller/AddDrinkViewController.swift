//
//  AddDrinkViewController.swift
//  espresso
//
//  Created by Jennifer on 11/14/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import UIKit
import Eureka
import FirebaseDatabase
import FirebaseAuth

class AddDrinkViewController: FormViewController {

    // Label displaying price
    @IBOutlet weak var priceLabel: UILabel!
    
    // Drink buttons
    @IBOutlet weak var coffeeButton: UIButton!
    @IBOutlet weak var bobaButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    // Keypad buttons
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    
    // Variables to hold values
    var price: Int = 0
    var drink: String = "coffee"
    
    // Firebase
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    let dateFormatter = DateFormatter()

    // Drink button pressed
    @IBAction func drinkPressed(_ sender: UIButton) {
        switch sender {
        case coffeeButton:
            coffeeButton.backgroundColor = UIColor(named: "MediumGrey")
            bobaButton.backgroundColor = UIColor(named: "Charcoal")
            otherButton.backgroundColor = UIColor(named: "Charcoal")
            drink = "coffee"
        case bobaButton:
            bobaButton.backgroundColor = UIColor(named: "MediumGrey")
            coffeeButton.backgroundColor = UIColor(named: "Charcoal")
            otherButton.backgroundColor = UIColor(named: "Charcoal")
            drink = "boba"
        case otherButton:
            otherButton.backgroundColor = UIColor(named: "MediumGrey")
            bobaButton.backgroundColor = UIColor(named: "Charcoal")
            coffeeButton.backgroundColor = UIColor(named: "Charcoal")
            drink = "other"
        default:
            print("error, button is not drink")
        }
    }
    
    // Number button pressed
    @IBAction func numberPressed(_ sender: UIButton) {
        switch sender {
        case oneButton:
            price = price * 10 + 1
        case twoButton:
            price = price * 10 + 2
        case threeButton:
            price = price * 10 + 3
        case fourButton:
            price = price * 10 + 4
        case fiveButton:
            price = price * 10 + 5
        case sixButton:
            price = price * 10 + 6
        case sevenButton:
            price = price * 10 + 7
        case eightButton:
            price = price * 10 + 8
        case nineButton:
            price = price * 10 + 9
        case zeroButton:
            price = price * 10
        default:
            print("error, button is not number")
        }
        priceLabel.text = formatMoney(amount: Double(price) / 100)
    }
    
    // Delete button pressed
    @IBAction func deletePressed(_ sender: UIButton) {
        price = Int(price / 10)
        priceLabel.text = formatMoney(amount: Double(price) / 100)
    }
    
    // Add drink
    @IBAction func addPressed(_ sender: UIButton) {
        let row: DateRow? = form.rowBy(tag: "myDateRow")
        let date = row?.value
        let priceDecimal: Double = Double(price) / 100
        let info: [String:Any] = ["date": dateFormatter.string(from: date!),
                                  "drink": drink,
                                  "price": priceDecimal]
        
        ref.child("Users").child((user?.uid)!).child("Transactions").childByAutoId().setValue(info)
        ref.child("Users").child((user?.uid)!).child("historyUpToDate").setValue(false)
        ref.child("Users").child((user?.uid)!).child("currentUpToDate").setValue(true)
        
        performSegue(withIdentifier: "unwindToHome", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize navigation bar
        self.navigationItem.title = "Add Drink"
        
        // Add date row
        form +++ Section() {
            // Hide header
            $0.header = HeaderFooterView<UIView>(HeaderFooterProvider.class)
            $0.header?.height = { CGFloat.leastNormalMagnitude }
            } <<< DateRow("myDateRow"){
                $0.title = "Date"
                $0.value = Date()
                }.cellUpdate {cell, row in
                    // Set custom font and color
                    cell.textLabel?.font = UIFont(name: "Open Sans", size: 18)
                    cell.detailTextLabel?.font = UIFont(name: "Open Sans", size: 18)
                    cell.tintColor = UIColor(named: "Green")
                    cell.height = ({ return 54 })
                }
        
        // Set date formatter
        dateFormatter.dateFormat = "MMM-dd-yyyy"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
