//
//  AddDrinkViewController.swift
//  espresso
//
//  Created by Jennifer on 11/14/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import UIKit
import Eureka

class AddDrinkViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date()
                }.cellUpdate {cell, row in
                    cell.textLabel?.font = UIFont(name: "Open Sans", size: 18)
                    cell.tintColor = UIColor(named: "Green")
                    cell.detailTextLabel?.font = UIFont(name: "Open Sans", size: 18)
                }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
