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
        animateScroll = true
        form +++ Section()
            <<< DateInlineRow(){
                $0.title = "Date Row"
                $0.value = Date()
            }
            <<< SegmentedRow<String>("segments"){
                $0.options = ["Coffee", "Boba", "Other"]
                $0.value = "Coffee"
            }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
