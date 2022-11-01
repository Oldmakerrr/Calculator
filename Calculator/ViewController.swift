//
//  ViewController.swift
//  Calculator
//
//  Created by Vladimir Berezin on 14.10.22.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    
    @IBOutlet weak var display: UILabel!
    
    var isUserInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text else { return }
        if isUserInTheMiddleOfTyping {
            guard let textCurrentInDisplay = display.text else { return }
            display.text = textCurrentInDisplay + digit
        } else {
            display.text = digit
            isUserInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if isUserInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            isUserInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.titleLabel?.text {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
}

