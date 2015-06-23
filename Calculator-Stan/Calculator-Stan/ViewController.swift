//
//  ViewController.swift
//  Calculator-Stan
//
//  Created by Adam Wyeth on 5/8/15.
//  Copyright (c) 2015 Stanford. All rights reserved.
//

import UIKit

//Should probably be something like "calculator View Controller"
//Can't just change name because it has to be synced with UI
class ViewController: UIViewController {

    //weak has something to do with memory management
    // but we don't have to do memory management here
    //This is a pointer, everything is a pointer if it's an object
    //This is an optional line is same as
    //@IBOutlet weak var display: UILabel! = nil
    //! instead of ?-> "always automatically unwrap"
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display.adjustsFontSizeToFitWidth = true
        history.adjustsFontSizeToFitWidth = true
    }
    
    //If type can be inferred, you shouldn't specify it
    var userIsIntheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsIntheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsIntheMiddleOfTypingANumber = true
        }
        println("digit = \(digit)")
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsIntheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
               
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        if userIsIntheMiddleOfTypingANumber {
            if let result = display.text!.rangeOfString(".") {
            } else {
                display.text = display.text! + "."
            }
        } else {
            display.text = "."
            userIsIntheMiddleOfTypingANumber = true
        }
    }
    
    
    //Apparently these need to be private in Swift 1.2 due to new
    //interactions with objective c
    /*private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
        }
    }*/
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsIntheMiddleOfTypingANumber = false
        //history.text = history.text! + " " + display.text!
        if let val = displayValue {
            let result = brain.pushOperand(val)
            displayValue = result!
           
        } else {
            displayValue = nil
        }
    }
    
    
    //Computed property
    var displayValue: Double? {
        get {
            if let value = NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
                return value
            } else {
                return nil
            }
        }
        set {
            //Magic variable
            history.text = brain.description
            if let val = newValue {
                display.text = "\(val)"
            }
            else {
                display.text = " "
            }
            userIsIntheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func setVar(sender: AnyObject) {
        
        let varString = sender.currentTitle!!
        let varName = varString.substringFromIndex(varString.startIndex.successor())
        if let value = displayValue {
            brain.variableValues[varName] = value
        }
        let result = brain.evaluate()
        displayValue = result
        userIsIntheMiddleOfTypingANumber = false
    }
    
    @IBAction func pushVar(sender: UIButton) {
        let varName = sender.currentTitle!
        if userIsIntheMiddleOfTypingANumber {
            enter()
            userIsIntheMiddleOfTypingANumber = false
        }
        
        if let result = brain.pushOperand(varName) {
            displayValue = result
           
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        userIsIntheMiddleOfTypingANumber = false
        brain = CalculatorBrain()
        display.text = " "
        history.text = " "
        
    }
    
}

