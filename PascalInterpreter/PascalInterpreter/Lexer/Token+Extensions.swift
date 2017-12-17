//
//  Token+Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 09/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case let (.operation(left), .operation(right)):
            return left == right
        case (.eof, .eof):
            return true
        case let (.type(left), .type(right)):
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
        case (.program, .program):
            return true
        case (.varDef, .varDef):
            return true
        case (.colon, .colon):
            return true
        case (.coma, .coma):
            return true
        case let (.constant(left), .constant(right)):
            return left == right
        case (.procedure, .procedure):
            return true
        case (.if, .if):
            return true
        case (.else, .else):
            return true
        case (.equals, .equals):
            return true
        case (.then, .then):
            return true
        case (.lessThan, .lessThan):
            return true
        case (.greaterThan, .greaterThan):
            return true
        case (.function, .function):
            return true
        case (.apostrophe, .apostrophe):
            return true
        default:
            return false
        }
    }
}

extension Constant: Equatable {
    public static func == (lhs: Constant, rhs: Constant) -> Bool {
        switch (lhs, rhs) {
        case let (.integer(left), .integer(right)):
            return left == right
        case let (.real(left), .real(right)):
            return left == right
        case let (.boolean(left), .boolean(right)):
            return left == right
        case let (.string(left), .string(right)):
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
        case .integerDiv:
            return "DIV"
        case .floatDiv:
            return "FDIV"
        }
    }
}

extension Type: CustomStringConvertible {
    public var description: String {
        switch self {
        case .integer:
            return "INTEGER"
        case .real:
            return "REAL"
        case .boolean:
            return "BOOLEAN"
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

extension Constant: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .integer(value):
            return "INTEGER_CONST(\(value))"
        case let .real(value):
            return "REAL_CONST(\(value))"
        case let .boolean(value):
            return "BOOLEAN_CONST(\(value))"
        case let .string(value):
            return "STRING_CONST(\(value))"
        }
    }
}

extension Token: CustomStringConvertible {
    public var description: String {
        switch self {
        case .eof:
            return "EOF"
        case let .operation(operation):
            return operation.description
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
        case .program:
            return "PROGRAM"
        case .varDef:
            return "VAR"
        case .colon:
            return ":"
        case .coma:
            return ","
        case let .parenthesis(paren):
            return paren.description
        case let .type(type):
            return type.description
        case let .constant(constant):
            return constant.description
        case .procedure:
            return "PROCEDURE"
        case .if:
            return "IF"
        case .else:
            return "ELSE"
        case .then:
            return "THEN"
        case .equals:
            return "EQ"
        case .lessThan:
            return "LT"
        case .greaterThan:
            return "GT"
        case .function:
            return "FUNCTION"
        case .apostrophe:
            return "APOSTROPHE"
        }
    }
}
