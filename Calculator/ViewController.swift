//
//  ViewController.swift
//  Calculator
//
//  Created by Denis Thamrin on 28/01/2015.
//  Copyright (c) 2015 ___DenisThamrin___. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var display: UILabel!
    @IBOutlet var history: UILabel!

    var userInMiddleOfTypingANumber: Bool = false

    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if !(digit == "." && display.text!.rangeOfString(".") != nil){
        
        
            if userInMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userInMiddleOfTypingANumber = true
            }
        }
        
    
        
        
        
    }
    @IBAction func operate(sender: UIButton) {
        if userInMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            }
            else {
                displayValue = 0
            }
        }
    }


    @IBAction func clear() {
        self.brain = CalculatorBrain()
        display.text = "0"
        history.text = nil
    }
 
    
    @IBAction func enter() {
        userInMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            if newValue != nil {
                display.text = "\(newValue!)"
                history.text = brain.printOps()
            }
            else {
                display.text = " "
                
            }
            
           
        }
    }

}

