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
    
    //If type can be inferred, you shouldn't specify it
    var userIsIntheMiddleOfTypingANumber = false
    var userIsTypingAfterDecimalPoint = false
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
                displayValue = 0
            }
        }
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        if !userIsTypingAfterDecimalPoint {
            display.text = display.text! + "."
        }
    }
    
    
    //Apparently these need to be private in Swift 1.2 due to new
    //interactions with objective c
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
        }
    }
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsIntheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            //really wish displayValue was an optional
            displayValue = 0
        }
    }
    
    
    //Computed property
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            //Magic variable
            display.text = "\(newValue)"
            userIsIntheMiddleOfTypingANumber = false
        }
    }
    
    
}

