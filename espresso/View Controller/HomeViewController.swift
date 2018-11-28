//
//  HomeViewController.swift
//  espresso
//
//  Created by Jennifer on 11/14/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Outlets to labels and views
    @IBOutlet weak var drinkNumLabel: UILabel!
    @IBOutlet weak var drinkTotalLabel: UILabel!
    @IBOutlet weak var totalBar: UIView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var moneySpentLabel: UILabel!
    @IBOutlet weak var moneyLeftLabel: UILabel!
    
    
    // Add drink button pressed
    @IBAction func addPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToAddDrink", sender: sender)
    }
    
    // Unwind from Add Drink to Home
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


