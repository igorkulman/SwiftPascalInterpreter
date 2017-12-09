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
    private var globalScope: [String: Int] = [:]

    public init(_ text: String) {
        parser = Parser(text)
    }

    @discardableResult private func visit(_ node: AST) -> Int? {
        switch node {
        case let .number(value):
            return value
        case let .unaryOperation(operation: operation, child: child):
            guard let result = visit(child) else {
                fatalError("Cannot use unary \(operation) on non number")
            }
            switch operation {
            case .plus:
                return +result
            case .minus:
                return -result
            }
        case let .binaryOperation(left: left, operation: operation, right: right):
            guard let leftResult = visit(left), let rightResult = visit(right) else {
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
                return leftResult / rightResult
            case .floatDiv:
                return leftResult / rightResult
            }
        case let .compound(children):
            for chid in children {
                visit(chid)
            }
            return nil
        case let .assignment(left, right):
            switch left {
            case let .variable(name):
                globalScope[name] = visit(right)!
                return nil
            default:
                fatalError("Assignment left side is not a variable")
            }
        case let .variable(name):
            guard let value = globalScope[name] else {
                fatalError("Variable \(name) not found")
            }
            return value
        case .noOp:
            return nil
        case .block(let declarations, let compound):
            for declaration in declarations {
                visit(declaration)
            }
            return visit(compound)
        case .variableDeclaration:
            return nil
        case .type:
            return nil
        case let .program(_, block):
            return visit(block)
        }
    }

    public func interpret() {
        let tree = parser.parse()
        visit(tree)
    }

    func getState() -> [String: Int] {
        return globalScope
    }

    public func printState() {
        print(globalScope)
    }
}
