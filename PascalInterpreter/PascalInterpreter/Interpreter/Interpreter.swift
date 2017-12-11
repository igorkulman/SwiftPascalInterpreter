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
    private let symbolTable: SymbolTable
    private let tree: AST

    public init(_ text: String) {
        let parser = Parser(text)
        tree = parser.parse()
        let semanticAnalyzer = SemanticAnalyzer()
        symbolTable = semanticAnalyzer.build(node: tree)
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
                fatalError("Assignment left side is not a variable")
            }

            guard let symbol = symbolTable.lookup(name), case let .variable(name: _, type: type) = symbol else {
                fatalError("Variable \(name) not in the symbol table")
            }

            switch type {
            case .integer:
                switch eval(right)! {
                case let .integer(value):
                    integerMemory[name] = value
                case .real:
                    fatalError("Cannot assign real value to Int variable \(name)")
                }
                return nil
            case .real:
                switch eval(right)! {
                case let .integer(value):
                    realMemory[name] = Double(value)
                case let .real(value):
                    realMemory[name] = value
                }
                return nil
            }
        case let .variable(name):
            guard let symbol = symbolTable.lookup(name), case let .variable(name: _, type: type) = symbol else {
                fatalError("Variable \(name) not in the symbol table")
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
            // process by the symbol table
            return nil
        case .type:
            return nil
        case let .program(_, block):
            return eval(block)
        case .procedure:
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
