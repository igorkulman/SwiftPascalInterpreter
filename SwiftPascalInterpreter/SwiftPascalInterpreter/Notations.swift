//
//  Notations.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 08/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public protocol Notation {
    func eval() -> String
}

/**
 Reverse polish notation
 */
public class RPN: Notation {
    private let parser: Parser

    public init(_ text: String) {
        parser = Parser(text)
    }

    public func eval() -> String {
        let node = parser.expr()
        return visit(node)
    }

    private func visit(_ node: AST) -> String {
        switch node {
        case let .number(value):
            return "\(value)"
        case let .binaryOperation(left: left, operation: operation, right: right):
            return "\(visit(left)) \(visit(right)) \(operation.shortDescription)"
        }
    }
}

/**
 LISP notation
 */
public class LISPNotation: Notation {
    private let parser: Parser

    public init(_ text: String) {
        parser = Parser(text)
    }

    public func eval() -> String {
        let node = parser.expr()
        return visit(node)
    }

    private func visit(_ node: AST) -> String {
        switch node {
        case let .number(value):
            return "\(value)"
        case let .binaryOperation(left: left, operation: operation, right: right):
            return "(\(operation.shortDescription) \(visit(left)) \(visit(right)))"
        }
    }
}
