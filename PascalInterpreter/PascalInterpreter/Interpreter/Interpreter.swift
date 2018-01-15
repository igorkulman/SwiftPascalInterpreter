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

    public init(_ text: String) {
        let parser = Parser(text)
        tree = parser.parse()
        let semanticAnalyzer = SemanticAnalyzer()
        scopes = semanticAnalyzer.analyze(node: tree)
    }

    @discardableResult func eval(node: AST) -> Value {
        switch node {
        case let number as Number:
            return eval(number: number)
        case let string as String:
            return eval(string: string)
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
        case let call as FunctionCall:
            return eval(call: call)
        case let condition as Condition:
            return eval(condition: condition)
        case let ifElse as IfElse:
            return eval(ifElse: ifElse)
        case let repeatUntil as RepeatUntil:
            return eval(repeatUntil: repeatUntil)
        case let whileLoop as While:
            return eval(whileLoop: whileLoop)
        case let forLoop as For:
            return eval(forLoop: forLoop)
        default:
            return .none
        }
    }

    func eval(number: Number) -> Value {
        return .number(number)
    }

    func eval(string: String) -> Value {
        return .string(string)
    }

    func eval(unaryOperation: UnaryOperation) -> Value {
        guard case let .number(result) = eval(node: unaryOperation.operand) else {
            fatalError("Cannot use unary \(unaryOperation.operation) on non number")
        }

        switch unaryOperation.operation {
        case .plus:
            return .number(+result)
        case .minus:
            return .number(-result)
        }
    }

    func eval(binaryOperation: BinaryOperation) -> Value {
        guard case let .number(leftResult) = eval(node: binaryOperation.left), case let .number(rightResult) = eval(node: binaryOperation.right) else {
            fatalError("Cannot use binary \(binaryOperation.operation) on non numbers")
        }

        switch binaryOperation.operation {
        case .plus:
            return .number(leftResult + rightResult)
        case .minus:
            return .number(leftResult - rightResult)
        case .mult:
            return .number(leftResult * rightResult)
        case .integerDiv:
            return .number(leftResult ‖ rightResult)
        case .floatDiv:
            return .number(leftResult / rightResult)
        }
    }

    func eval(compound: Compound) -> Value {
        for child in compound.children {
            eval(node: child)
        }
        return .none
    }

    func eval(assignment: Assignment) -> Value {
        guard let currentFrame = callStack.peek() else {
            fatalError("No call stack frame")
        }

        switch assignment.left {
        case let array as ArrayVariable:
            guard case let .number(.integer(index)) = eval(node: array.index) else {
                fatalError("Cannot use non-Integer index with array '\(array.name)'")
            }
            currentFrame.set(variable: assignment.left.name, value: eval(node: assignment.right), index: index)
        default:
            currentFrame.set(variable: assignment.left.name, value: eval(node: assignment.right))
        }

        return .none
    }

    func eval(variable: Variable) -> Value {
        guard let currentFrame = callStack.peek() else {
            fatalError("No call stack frame")
        }

        switch variable {
        case let array as ArrayVariable:
            guard case let .number(.integer(index)) = eval(node: array.index) else {
                fatalError("Cannot use non-Integer index with array '\(array.name)'")
            }
            return currentFrame.get(variable: array.name, index: index)
        default:
            return currentFrame.get(variable: variable.name)
        }
    }

    func eval(block: Block) -> Value {
        for declaration in block.declarations {
            eval(node: declaration)
        }

        return eval(node: block.compound)
    }

    func eval(program: Program) -> Value {
        let frame = Frame(scope: scopes["global"]!, previousFrame: nil)
        callStack.push(frame)
        return eval(node: program.block)
    }

    func eval(call: FunctionCall) -> Value {
        let current = callStack.peek()!

        guard let symbol = current.scope.lookup(call.name), symbol is ProcedureSymbol else {
            return callBuiltInProcedure(procedure: call.name, params: call.actualParameters, frame: current)
        }

        return callFunction(function: call.name, params: call.actualParameters, frame: current)
    }

    func eval(condition: Condition) -> Value {
        let left = eval(node: condition.leftSide)
        let right = eval(node: condition.rightSide)

        switch condition.type {
        case .equals:
            return .boolean(left == right)
        case .greaterThan:
            return .boolean(left > right)
        case .lessThan:
            return .boolean(left < right)
        }
    }

    func eval(ifElse: IfElse) -> Value {
        guard case let .boolean(value) = eval(condition: ifElse.condition) else {
            fatalError("Condition not boolean")
        }

        if value {
            return eval(node: ifElse.trueExpression)
        } else if let falseExpression = ifElse.falseExpression {
            return eval(node: falseExpression)
        } else {
            return .none
        }
    }

    func eval(repeatUntil: RepeatUntil) -> Value {
        eval(node: repeatUntil.statement)
        var value = eval(condition: repeatUntil.condition)

        while case .boolean(false) = value {
            eval(node: repeatUntil.statement)
            value = eval(condition: repeatUntil.condition)
        }

        return .none
    }

    func eval(whileLoop: While) -> Value {
        while case .boolean(true) = eval(condition: whileLoop.condition) {
            eval(node: whileLoop.statement)
        }

        return .none
    }

    func eval(forLoop: For) -> Value {
        guard let currentFrame = callStack.peek() else {
            fatalError("No call stack frame")
        }

        guard case let .number(.integer(start)) = eval(node: forLoop.startValue), case let .number(.integer(end)) = eval(node: forLoop.endValue) else {
            fatalError("Cannot do a for loop on non integer values")
        }

        for i in start ... end {
            currentFrame.set(variable: forLoop.variable.name, value: .number(.integer(i)))
            eval(node: forLoop.statement)
        }
        currentFrame.remove(variable: forLoop.variable.name)

        return .none
    }

    private func callFunction(function: String, params: [AST], frame: Frame) -> Value {
        guard let symbol = frame.scope.lookup(function), let procedureSymbol = symbol as? ProcedureSymbol else {
            fatalError("Symbol(procedure) not found '\(function)'")
        }

        let newScope = frame.scope.level == 1 ? scopes[function]! : ScopedSymbolTable(name: function, level: scopes[function]!.level + 1, enclosingScope: scopes[function]!)
        let newFrame = Frame(scope: newScope, previousFrame: frame)

        if procedureSymbol.params.count > 0 {

            for i in 0 ... procedureSymbol.params.count - 1 {
                let evaluated = eval(node: params[i])
                newFrame.set(variable: procedureSymbol.params[i].name, value: evaluated)
            }
        }

        callStack.push(newFrame)
        eval(node: procedureSymbol.body.block)
        callStack.pop()
        return newFrame.returnValue
    }

    public func interpret() {
        eval(node: tree)
    }

    func getState() -> ([String: Value], [String: [Value]]) {
        return (callStack.peek()!.scalars, callStack.peek()!.arrays)
    }

    public func printState() {
        print("Final interpreter memory state (\(callStack.peek()!.scope.name)):")
        print(callStack.peek()!.scalars)
        print(callStack.peek()!.arrays)
    }
}
