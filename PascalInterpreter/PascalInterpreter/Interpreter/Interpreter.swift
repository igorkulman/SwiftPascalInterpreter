//
//  Interpreter.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class Interpreter {
    private var integerMemory: [String: Int] = [:]
    private var realMemory: [String: Double] = [:]
    private let tree: AST

    public init(_ text: String) {
        let parser = Parser(text)
        tree = parser.parse()
        let semanticAnalyzer = SemanticAnalyzer()
        semanticAnalyzer.analyze(node: tree)
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
            guard case let .variable(name) = left else {
                fatalError("Assignment left side is not a variable, check Parser implementation")
            }

            if integerMemory.keys.contains(name) {
                switch eval(right)! {
                case let .integer(value):
                    integerMemory[name] = value
                    return nil
                case .real:
                    fatalError("Cannot assign Real value to Int variable \(name)")
                }
            }

            if realMemory.keys.contains(name) {
                switch eval(right)! {
                case let .integer(value):
                    realMemory[name] = Double(value)
                    return nil
                case let .real(value):
                    realMemory[name] = value
                    return nil
                }
            }

            fatalError("Variable \(name) not found, check the SemanticAnalyzer implementation")
        case let .variable(name):
            if let value = integerMemory[name] {
                return .integer(value)
            }
            if let value = realMemory[name] {
                return .real(value)
            }
            fatalError("Variable \(name) not found, check the SemanticAnalyzer implementation")
        case .noOp:
            return nil
        case let .block(declarations, compound):
            for declaration in declarations {
                eval(declaration)
            }
            return eval(compound)
        case let .variableDeclaration(name: name, type: type):
            guard case let .type(type) = type, case let .variable(name: name) = name else {
                fatalError("Invalid variable declaration, check Parser implementation")
            }
            switch type {
            case .integer:
                integerMemory[name] = 0
            case .real:
                realMemory[name] = 0
            }
            return nil
        case .type:
            return nil
        case let .program(_, block):
            return eval(block)
        case .procedure:
            return nil
        case .param:
            return nil
        }
    }

    public func interpret() {
        eval(tree)
    }

    func getState() -> ([String: Int], [String: Double]) {
        return (integerMemory, realMemory)
    }

    public func printState() {
        print("Final interpreter memory state:")
        print("Int: \(integerMemory)")
        print("Real: \(realMemory)")
    }
}
