//
//  NumbersCell.swift
//  espresso
//
//  Created by Jennifer on 11/19/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public class NumbersCell: Cell<String>, CellType {
    @IBOutlet var numbersView: UIView!
    
//    @IBOutlet var oneButton: UIButton!
//    @IBOutlet var twoButton: UIButton!
//    @IBOutlet var threeButton: UIButton!
//    @IBOutlet var fourButton: UIButton!
//    @IBOutlet var fiveButton: UIButton!
//    @IBOutlet var sixButton: UIButton!
//    @IBOutlet var sevenButton: UIButton!
//    @IBOutlet var eightButton: UIButton!
//    @IBOutlet var nineButton: UIButton!
//    @IBOutlet var deleteButton: UIButton!
//    @IBOutlet var zeroButton: UIButton!
    
//    @IBAction func numberTapped(_ sender: UIButton) {
//        if sender == deleteButton {
//
//        } else {
//            row.value = row.value! + sender.titleLabel!.text!
//        }
//        print(row.value!)
//    }

//    open override func setup() {
//        super.setup()
//    }
//    
//    open override func update() {
//        super.update()
//    }
}

public final class NumbersRow: Row<NumbersCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<NumbersCell>(nibName: "NumbersCell")
    }

}
