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
        case .operation:
            currentToken = lexer.getNextToken()
        default:
            fatalError("Expected plus, got \(currentToken)")
        }
    }

    /**
     Factor for the grammar described in the `expr` method

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
     factor : INTEGER

     Returns: Int value
     */
    public func expr() -> Int {

        var result = factor()

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
