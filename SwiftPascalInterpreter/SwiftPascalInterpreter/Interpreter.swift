//
//  Interpreter.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class Interpreter {
    private let lexer: Lexer
    private var currentToken: Token

    public init(_ text: String) {
        lexer = Lexer(text)
        currentToken = lexer.getNextToken()
    }

    private func eatInteger() {
        switch currentToken {
        case .integer:
            currentToken = lexer.getNextToken()
        default:
            fatalError("Expected integer, got \(currentToken)")
        }
    }

    private func eatOperation() {
        switch currentToken {
        case .operation:
            currentToken = lexer.getNextToken()
        default:
            fatalError("Expected plus, got \(currentToken)")
        }
    }

    /**
     Factor

     Returns: Int value
     */
    func factor() -> Int {
        let token = currentToken
        eatInteger()
        switch token {
        case let .integer(value):
            return value
        default:
            fatalError("Syntax error")
        }
    }

    /**
     Arithmetic expression parser

     expr   : factor ((MUL | DIV | PLUS | MINUS) factor)*
     factor : INTEGER

     Returns: Int value
     */
    public func expr() -> Int {

        var result = factor()

        while [.operation(.plus), .operation(.minus), .operation(.mult), .operation(.div)].contains(currentToken) {
            switch currentToken {
            case let .operation(operation):
                eatOperation()
                switch operation {
                case .plus:
                    result += factor()
                case .minus:
                    result -= factor()
                case .mult:
                    result *= factor()
                case .div:
                    result /= factor()
                }
            default:
                fatalError("Syntax error")
            }
        }

        return result
    }
}
