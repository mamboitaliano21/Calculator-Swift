//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Denis Thamrin on 3/02/2015.
//  Copyright (c) 2015 ___DenisThamrin___. All rights reserved.
//

import Foundation

class CalculatorBrain{
    private enum Op : Printable {
        case Operand(Double)
        case Variable(String,Double?)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String,(Double,Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol, let value):
                    // try return "symbol = value"
                    if value != nil{
                        return "\(symbol) = \(value!)"
                    }
                    else {
                        return "\(symbol) = nil"
                    }
                    
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    var variableValues = Dictionary<String,Double> ()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷"){ $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√",sqrt)
        knownOps["π"] = Op.Operand(M_PI)
        knownOps["sin"] = Op.UnaryOperation("sin",sin)
        knownOps["cos"] = Op.UnaryOperation("cos",cos)
        
    }
    
    private func evaluate(ops: [Op]) -> (result:Double?, remainingOps: [Op])
    {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand =  operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1,operand2),op2Evaluation.remainingOps)
                        }
                    }
            case .Variable(_, let value):
                    assert(false,"not implemented")
                }

            
            }
        
        return (nil,ops)
    }

    func evaluate() -> Double? {
        let ( result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over)")
        return result
    }
    
    func pushOperand(operand:Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol,nil))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func printOps() -> NSString{
        return "\(opStack)"

    }
}