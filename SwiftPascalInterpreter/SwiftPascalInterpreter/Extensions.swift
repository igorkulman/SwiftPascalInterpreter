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
        case (.dot, .dot):
            return true
        case (.semi, .semi):
            return true
        case (.assign, .assign):
            return true
        case (.begin, .begin):
            return true
        case (.end, .end):
            return true
        case let (.id(left), .id(right)):
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

extension BinaryOperation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minus:
            return "-"
        case .plus:
            return "+"
        case .mult:
            return "*"
        case .div:
            return "/"
        }
    }
}

extension UnaryOperation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minus:
            return "-"
        case .plus:
            return "+"
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
        case .begin:
            return "BEGIN"
        case .end:
            return "END"
        case let .id(value):
            return "ID(\(value))"
        case .assign:
            return "ASSIGN"
        case .semi:
            return "SEMI"
        case .dot:
            return "DOT"
        }
    }
}

extension Lexer: CustomStringConvertible {
    public var description: String {
        return "Lexer"
    }
}

extension Interpreter: CustomStringConvertible {
    public var description: String {
        return "Interpreter"
    }
}

extension Parser: CustomStringConvertible {
    public var description: String {
        return "Parser"
    }
}

extension RPN: CustomStringConvertible {
    public var description: String {
        return "Reverse polish notation"
    }
}

extension LISPNotation: CustomStringConvertible {
    public var description: String {
        return "LISP notation"
    }
}

extension AST: CustomStringConvertible {
    public var description: String {
        return treeString(self, using: { node in
            switch node {
            case let .number(value):
                return ("\(value)", nil, nil)
            case let .unaryOperation(operation: operation, child: child):
                return ("u\(operation.description)", child, nil)
            case let .binaryOperation(left: left, operation: operation, right: right):
                return ("\(operation.description)", left, right)
            }
        })
    }
}

extension AST: Equatable {
    public static func == (lhs: AST, rhs: AST) -> Bool {
        switch (lhs, rhs) {
        case let (.number(left), .number(right)):
            return left == right
        case let (.unaryOperation(operation: leftOperation, child: leftChild),
                  .unaryOperation(operation: rightOperation, child: rightChild)):
            return leftOperation == rightOperation && leftChild == rightChild
        case let (.binaryOperation(left: leftLeft, operation: leftOperation, right: leftRight),
                  .binaryOperation(left: rightLeft, operation: rightOperation, right: rightRight)):
            return leftLeft == rightLeft && leftOperation == rightOperation && leftRight == rightRight
        default:
            return false
        }
    }
}
