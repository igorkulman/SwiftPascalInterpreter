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

    public init(_ text: String) {
        parser = Parser(text)
    }

    public func eval() -> Int {
        /*let node = parser.expr()
        return visit(node)*/
        return 0
    }

    /*private func visit(_ node: AST) -> Int {
        switch node {
        case let .number(value):
            return value
        case let .unaryOperation(operation: operation, child: child):
            switch operation {
            case .plus:
                return +visit(child)
            case .minus:
                return -visit(child)
            }
        case let .binaryOperation(left: left, operation: operation, right: right):
            switch operation {
            case .plus:
                return visit(left) + visit(right)
            case .minus:
                return visit(left) - visit(right)
            case .mult:
                return visit(left) * visit(right)
            case .div:
                return visit(left) / visit(right)
            }
        }
    }*/
}
