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
        case (.plus, .plus):
            return true
        case (.minus, .minus):
            return true
        case (.mult, .mult):
            return true
        case (.floatDiv, .floatDiv):
            return true
        case (.integerDiv, .integerDiv):
            return true
        case (.eof, .eof):
            return true
        case (.integer, .integer):
            return true
        case (.real, .real):
            return true
        case (.lparen, .lparen):
            return true
        case (.rparen, .rparen):
            return true
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
        case let (.integerConst(left), .integerConst(right)):
            return left == right
        default:
            return false
        }
    }
}

extension Token: CustomStringConvertible {
    public var description: String {
        switch self {
        case .eof:
            return "EOF"
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
        case .integer:
            return "INTEGER"
        case .real:
            return "REAL"
        case let .integerConst(value):
            return "INTEGER_CONST(\(value))"
        case let .realConst(value):
            return "REAL_CONST(\(value))"
        case .lparen:
            return "LPAREN"
        case .rparen:
            return "RPAREN"
        }
    }
}
