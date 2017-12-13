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
    private let scopes: [String: ScopedSymbolTable]
    private var currentScope: ScopedSymbolTable!

    public init(_ text: String) {
        let parser = Parser(text)
        tree = parser.parse()
        let semanticAnalyzer = SemanticAnalyzer()
        scopes = semanticAnalyzer.analyze(node: tree)
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

            guard let symbol = currentScope.lookup(name), case let .variable(name: _, type: .builtIn(type)) = symbol else {
                fatalError("Variable \(name) not found, check the SemanticAnalyzer implementation")
            }

            switch type {
            case .integer:
                switch eval(right)! {
                case let .integer(value):
                    integerMemory[name] = value
                    return nil
                case .real:
                    fatalError("Cannot assign Real value to Int variable \(name)")
                }
            case .real:
                switch eval(right)! {
                case let .integer(value):
                    realMemory[name] = Double(value)
                    return nil
                case let .real(value):
                    realMemory[name] = value
                    return nil
                }
            }
        case let .variable(name):
            guard let symbol = currentScope.lookup(name), case let .variable(name: _, type: .builtIn(type)) = symbol else {
                fatalError("Variable \(name) not found, check the SemanticAnalyzer implementation")
            }

            switch type {
            case .integer:
                return .integer(integerMemory[name]!)
            case .real:
                return .real(realMemory[name]!)
            }
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
            currentScope = scopes["global"]
            return eval(block)
        case .procedure:
            return nil
        case .param:
            return nil
        case let .call(procedureName: name):
            let previousScope = currentScope
            currentScope = scopes[name]
            print("calling \(name)")
            currentScope = previousScope
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
