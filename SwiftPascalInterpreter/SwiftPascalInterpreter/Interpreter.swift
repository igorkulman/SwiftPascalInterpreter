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

    private func eatOperation(_ operation: Operation) {
        switch currentToken {
        case .operation(operation):
            currentToken = lexer.getNextToken()
        default:
            fatalError("Expected \(operation), got \(currentToken)")
        }
    }

    private func eatParenthesis(_ parenthesis: Parenthesis) {
        switch currentToken {
        case .parenthesis(parenthesis):
            currentToken = lexer.getNextToken()
        default:
            fatalError("Expected \(parenthesis), got \(currentToken)")
        }
    }

    /**
     Factor for the grammar described in the `expr` method

     Returns: Int value
     */
    func factor() -> Int {
        let token = currentToken
        switch token {
        case let .integer(value):
            eatInteger()
            return value
        case .parenthesis(.left):
            eatParenthesis(.left)
            let result = expr()
            eatParenthesis(.right)
            return result
        default:
            fatalError("Syntax error")
        }
    }

    /**
     Term for the grammar described in the `expr` method

     Returns: Int value
     */
    func term() -> Int {
        var result = factor()

        while [.operation(.mult), .operation(.div)].contains(currentToken) {
            if currentToken == .operation(.mult) {
                eatOperation(.mult)
                result *= term()
            } else if currentToken == .operation(.div) {
                eatOperation(.div)
                result /= term()
            }
        }

        return result
    }

    /**
     Arithmetic expression parser

     expr   : term (PLUS | MINUS) term)*
     term   : factor ((MUL | DIV) factor)*
     factor : INTEGER | LPAREN factor RPAREN

     Returns: Int value
     */
    public func expr() -> Int {

        var result = term()

        while [.operation(.plus), .operation(.minus)].contains(currentToken) {
            if currentToken == .operation(.plus) {
                eatOperation(.plus)
                result += term()
            } else if currentToken == .operation(.minus) {
                eatOperation(.minus)
                result -= term()
            }
        }

        return result
    }
}
