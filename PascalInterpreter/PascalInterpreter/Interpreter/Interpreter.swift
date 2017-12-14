//
//  Interpreter.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class Interpreter {
    private var callStack = Stack<Frame>()
    private let tree: AST
    private let scopes: [String: ScopedSymbolTable]
    private let procedures: [String: Procedure]

    public init(_ text: String) {
        let parser = Parser(text)
        tree = parser.parse()
        let semanticAnalyzer = SemanticAnalyzer()
        let data = semanticAnalyzer.analyze(node: tree)
        scopes = data.scopes
        procedures = data.procedures
    }

    @discardableResult private func eval(node: AST) -> Number? {
        switch node {
        case let number as Number:
            return eval(number: number)
        case let unaryOperation as UnaryOperation:
            return eval(unaryOperation: unaryOperation)
        case let binaryOperation as BinaryOperation:
            return eval(binaryOperation: binaryOperation)
        case let compound as Compound:
            return eval(compound: compound)
        case let assignment as Assignment:
            return eval(assignment: assignment)
        case let variable as Variable:
            return eval(variable: variable)
        case let block as Block:
            return eval(block: block)
        case let program as Program:
            return eval(program: program)
        case let call as ProcedureCall:
            return eval(call: call)
        default:
            return nil
        }
    }

    func eval(number: Number) -> Number? {
        return number
    }

    func eval(unaryOperation: UnaryOperation) -> Number? {
        guard let result = eval(node: unaryOperation.operand) else {
            fatalError("Cannot use unary \(unaryOperation.operation) on non number")
        }

        switch unaryOperation.operation {
        case .plus:
            return +result
        case .minus:
            return -result
        }
    }
    func eval(binaryOperation: BinaryOperation) -> Number? {
        guard let leftResult = eval(node: binaryOperation.left), let rightResult = eval(node: binaryOperation.right) else {
            fatalError("Cannot use binary \(binaryOperation.operation) on non numbers")
        }

        switch binaryOperation.operation {
        case .plus:
            return leftResult + rightResult
        case .minus:
            return leftResult - rightResult
        case .mult:
            return leftResult * rightResult
        case .integerDiv:
            return leftResult ‖ rightResult
        case .floatDiv:
            return leftResult / rightResult
        }
    }

    func eval(compound: Compound) -> Number? {
        for child in compound.children {
            eval(node: child)
        }
        return nil
    }

    func eval(assignment: Assignment) -> Number? {
        guard let currentFrame = callStack.peek() else {
            fatalError("No call stack frame")
        }

        currentFrame.set(variable: assignment.left.name, value: eval(node: assignment.right)!)
        return nil
    }

    func eval(variable: Variable) -> Number? {
        guard let currentFrame = callStack.peek() else {
            fatalError("No call stack frame")
        }

        return currentFrame.get(variable: variable.name)
    }

    func eval(block: Block) -> Number? {
        for declaration in block.declarations {
            eval(node: declaration)
        }

        return eval(node: block.compound)
    }

    func eval(program: Program) -> Number? {
        let frame = Frame(scope: scopes["global"]!, previousFrame: nil)
        callStack.push(frame)
        return eval(node: program.block)
    }

    func eval(call: ProcedureCall) -> Number? {
        let current = callStack.peek()!
        let frame = Frame(scope: scopes[call.name]!, previousFrame: current)
        callStack.push(frame)
        callProcedure(procedure: call.name, params: call.actualParameters, frame: frame)
        callStack.pop()
        return nil
    }

    private func callProcedure(procedure: String, params: [Number], frame: Frame) {
        guard let definition = procedures[procedure] else {
            fatalError("Procedure \(procedure) not in table, check SemanticAnalyzer implementation")
        }

        guard let symbol = frame.scope.lookup(procedure), case let Symbol.procedure(name: _, params: declaredParams) = symbol else {
            fatalError("Symbol(procedure) not found '\(procedure)'")
        }

        if declaredParams.count > 0 {

            for i in 0 ... declaredParams.count - 1 {
                guard case let Symbol.variable(name: name, type: Symbol.builtIn(_)) = declaredParams[i] else {
                    fatalError("Procedure declared with wrong parameters '\(procedure)'")
                }
                frame.set(variable: name, value: params[i])
            }
        }

        eval(node: definition.block)
    }

    public func interpret() {
        eval(node: tree)
    }

    func getState() -> ([String: Int], [String: Double]) {
        return (callStack.peek()!.integerMemory, callStack.peek()!.realMemory)
    }

    public func printState() {
        print("Final interpreter memory state (\(callStack.peek()!.scope.name)):")
        print("Int: \(callStack.peek()!.integerMemory)")
        print("Real: \(callStack.peek()!.realMemory)")
    }
}
