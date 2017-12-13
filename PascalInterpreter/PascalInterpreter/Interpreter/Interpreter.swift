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
    private let procedures: [String: AST]

    public init(_ text: String) {
        let parser = Parser(text)
        tree = parser.parse()
        let semanticAnalyzer = SemanticAnalyzer()
        let data = semanticAnalyzer.analyze(node: tree)
        scopes = data.scopes
        procedures = data.procedures
    }

    @discardableResult private func eval(_ node: AST) -> Number? {
        switch node {
        case let .number(value):
            return value
        case let .unaryOperation(operation: operation, child: child):
            guard let result = eval(child) else {
                fatalError("Cannot use unary \(operation) on non number")
            }
            switch operation {
            case .plus:
                return +result
            case .minus:
                return -result
            }
        case let .binaryOperation(left: left, operation: operation, right: right):
            guard let leftResult = eval(left), let rightResult = eval(right) else {
                fatalError("Cannot use binary \(operation) on non numbers")
            }
            switch operation {
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
        case let .compound(children):
            for chid in children {
                eval(chid)
            }
            return nil
        case let .assignment(left, right):
            guard let currentFrame = callStack.peek() else {
                fatalError("No call stack frame")
            }
            guard case let .variable(name) = left else {
                fatalError("Assignment left side is not a variable, check Parser implementation")
            }

            currentFrame.set(variable: name, value: eval(right)!)
            return nil
        case let .variable(name):
            guard let currentFrame = callStack.peek() else {
                fatalError("No call stack frame")
            }
            return currentFrame.get(variable: name)
        case .noOp:
            return nil
        case let .block(declarations, compound):
            for declaration in declarations {
                eval(declaration)
            }

            return eval(compound)
        case .variableDeclaration:
            // handled by the SemanticAnalyzer when building symbol table
            return nil
        case .type:
            return nil
        case let .program(_, block):
            let frame = Frame(currentScope: scopes["global"]!, previousFrame: nil)
            callStack.push(frame)
            return eval(block)
        case .procedure:
            return nil
        case .param:
            return nil
        case let .call(procedureName: name):
            let current = callStack.peek()!
            let frame = Frame(currentScope: scopes[name]!, previousFrame: current)
            callStack.push(frame)
            call(procedure: name)
            callStack.pop()
            return nil
        }
    }

    private func call(procedure: String) {
        guard let definition = procedures[procedure], case let .procedure(name: _, params: _, block: block) = definition else {
            fatalError("Procedure \(procedure) not in table, check SemanticAnalyzer implementation")
        }

        eval(block)
    }

    public func interpret() {
        eval(tree)
    }

    func getState() -> ([String: Int], [String: Double]) {
        return (callStack.peek()!.integerMemory, callStack.peek()!.realMemory)
    }

    public func printState() {
        print("Final interpreter memory state (\(callStack.peek()!.currentScope.name)):")
        print("Int: \(callStack.peek()!.integerMemory)")
        print("Real: \(callStack.peek()!.realMemory)")
    }
}
