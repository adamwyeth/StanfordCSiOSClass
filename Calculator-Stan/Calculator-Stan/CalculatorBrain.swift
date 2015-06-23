//
//  CalculatorBrain.swift
//  Calculator-Stan
//
//  Created by Adam Wyeth on 5/9/15.
//  Copyright (c) 2015 Stanford. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    //Implements Printable Protocol
    private enum Op: Printable {
        case Operand(Double)
        case ConstantOperation(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case VariableOperation(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .ConstantOperation(let symbol, _):
                    return symbol
                case .VariableOperation(let symbol):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //Currently only shows history of last calculation
    //TODO: add commas for history
    var description: String {
        get {
            
            let opStackCopy = opStack
            return describe(opStackCopy).description + "="
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    var variableValues: Dictionary<String,Double> = [String:Double]();
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        knownOps["✕"] = Op.BinaryOperation("✕", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["-"] = Op.BinaryOperation("-") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["π"] = Op.ConstantOperation("π", M_PI)
    }
    
    var program: AnyObject { //guaranteed to be a propertyList
        get {
            return opStack.map {$0.description}
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    
    //Note arrays and dictionaries are structs, structs are passed by value
    //while classes are passed by references
    //"implicit 'let' in front of all things you pass"
    //Seems like ops is copied 3 times, but doesn't actually copy unless it needs to
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return(operand, remainingOps)
            case .ConstantOperation(_, let constant):
                return(constant, remainingOps)
            case .VariableOperation(let symbol):
                if let value = variableValues[symbol] {
                    return (value, remainingOps)
                }
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    private func describe(ops:[Op]) -> (description: String, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand.description, remainingOps)
            case .ConstantOperation(let symbol, _):
                return (symbol, remainingOps)
            case .VariableOperation(let symbol):
                return (symbol, remainingOps)
            case .UnaryOperation(let symbol, _):
                let middle = describe(remainingOps)
                return (symbol + "(" + middle.description + ")", middle.remainingOps)
            case .BinaryOperation(let symbol, _):
                if remainingOps.isEmpty {
                    let empty = describe(remainingOps)
                    return ("(" + empty.description + symbol + empty.description + ")",
                        empty.remainingOps)
                } else {
                    let describeRightEval = describe(remainingOps)
                    let describeLeftEval = describe(describeRightEval.remainingOps)
                    return ("(" + describeLeftEval.description + symbol + describeRightEval.description + ")",
                        describeLeftEval.remainingOps)
                }
            }
        }
        return ("?", ops)
        
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.VariableOperation(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}