//
//  Interpreter.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class Interpreter {
    private let parser: Parser
    private var globalIntegers: [String: Int] = [:]
    private var globalReals: [String: Double] = [:]

    public init(_ text: String) {
        parser = Parser(text)
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
                switch result {
                case let .integer(value):
                    return .integer(+value)
                case let .real(value):
                    return .real(+value)
                }
            case .minus:
                switch result {
                case let .integer(value):
                    return .integer(-value)
                case let .real(value):
                    return .real(-value)
                }
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
            switch left {
            case let .variable(name):
                if globalIntegers.keys.contains(name) {
                    guard let result = eval(right) else {
                        fatalError("Cannot assign empty value to variable \(name)")
                    }
                    switch result {
                    case let .integer(value):
                        globalIntegers[name] = value
                    case .real:
                        fatalError("Cannot assign real value to Int variable \(name)")
                    }
                    return nil
                }
                if globalReals.keys.contains(name) {
                    guard let result = eval(right) else {
                        fatalError("Cannot assign empty value to variable \(name)")
                    }
                    switch result {
                    case let .integer(value):
                        globalReals[name] = Double(value)
                    case let .real(value):
                        globalReals[name] = value
                    }
                    return nil
                }
                fatalError("Cannot use undeclared variable \(name)")
            default:
                fatalError("Assignment left side is not a variable")
            }
        case let .variable(name):
            if let value = globalIntegers[name] {
                return .integer(value)
            }
            if let value = globalReals[name] {
                return .real(value)
            }
            fatalError("Variable \(name) not declared")
        case .noOp:
            return nil
        case let .block(declarations, compound):
            for declaration in declarations {
                eval(declaration)
            }
            return eval(compound)
        case let .variableDeclaration(name: variable, type: variableType):
            guard case let .variable(name) = variable, case let .type(type) = variableType else {
                fatalError("Invalid variable declaration")
            }
            switch type {
            case .integer:
                globalIntegers[name] = 0
            case .real:
                globalReals[name] = 0
            }
            return nil
        case .type:
            return nil
        case let .program(_, block):
            return eval(block)
        }
    }

    public func interpret() {
        let tree = parser.parse()
        eval(tree)
    }

    func getState() -> ([String: Int], [String: Double]) {
        return (globalIntegers, globalReals)
    }

    public func printState() {
        print("Final interpreter memory state:")
        print("Int: \(globalIntegers)")
        print("Real: \(globalReals)")
    }
}
