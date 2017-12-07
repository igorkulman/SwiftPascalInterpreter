//
//  Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension Character {
    var int: Int {
        return Int(String(self)) ?? 0
    }
}

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case let (.operation(left), .operation(right)):
            return left == right
        case (.eof, .eof):
            return true
        case let (.integer(left), .integer(right)):
            return left == right
        case let (.parenthesis(left), .parenthesis(right)):
            return left == right
        default:
            return false
        }
    }
}

extension Operation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minus:
            return "MINUS"
        case .plus:
            return "PLUS"
        case .mult:
            return "MULT"
        case .div:
            return "DIV"
        }
    }
}

extension Parenthesis: CustomStringConvertible {
    public var description: String {
        switch self {
        case .left:
            return "LPAREN"
        case .right:
            return "RPAREN"
        }
    }
}

extension Token: CustomStringConvertible {
    public var description: String {
        switch self {
        case .eof:
            return "EOF"
        case let .integer(value):
            return "INTEGER(\(value))"
        case let .operation(operation):
            return operation.description
        case let .parenthesis(parenthesis):
            return parenthesis.description
        }
    }
}
