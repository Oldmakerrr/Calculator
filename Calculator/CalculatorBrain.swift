//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Vladimir Berezin on 14.10.22.
//

import Foundation

struct CalculatorBrain {
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var accumulator: Double?
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private var operations: [String: Operation] = ["𝜋": Operation.constant(Double.pi),
                                                   "e": Operation.constant(M_E),
                                                   "√": Operation.unaryOperation(sqrt),
                                                   "cos": Operation.unaryOperation(cos),
                                                   "±": Operation.unaryOperation({ -$0 }),
                                                   "×": Operation.binaryOperation({ $0 * $1 }),
                                                   "÷": Operation.binaryOperation({ $0 / $1 }),
                                                   "+": Operation.binaryOperation({ $0 + $1 }),
                                                   "-": Operation.binaryOperation({ $0 - $1 }),
                                                   "=": Operation.equals]
 
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let operation):
                if let constant = accumulator {
                   accumulator = operation(constant)
                }
            case .binaryOperation(let operation):
                if let firstOperand = accumulator {
                    pendingBinaryOperation = PendingBinaryOperation(function: operation, firstOperand: firstOperand)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        guard let pbo = pendingBinaryOperation, let accumulator = accumulator else { return }
        self.accumulator = pbo.perform(with: accumulator)
        self.pendingBinaryOperation = nil
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        return accumulator
    }

}
