//
//  Parser.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 07/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class Parser {
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
    private func factor() -> AST {
        let token = currentToken
        switch token {
        case let .integer(value):
            eatInteger()
            return .number(value)
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
    private func term() -> AST {
        let node = factor()

        while [.operation(.mult), .operation(.div)].contains(currentToken) {
            let token = currentToken
            if token == .operation(.mult) {
                eatOperation(.mult)
                return .binaryOperation(left: node, operation: .mult, right: factor())
            } else if token == .operation(.div) {
                eatOperation(.div)
                return .binaryOperation(left: node, operation: .div, right: factor())
            }
        }

        return node
    }

    /**
     Arithmetic expression parser
     
     expr   : term (PLUS | MINUS) term)*
     term   : factor ((MUL | DIV) factor)*
     factor : INTEGER | LPAREN factor RPAREN
     
     Returns: Int value
     */
    public func expr() -> AST {

        let node = term()

        while [.operation(.plus), .operation(.minus)].contains(currentToken) {
            let token = currentToken
            if token == .operation(.plus) {
                eatOperation(.plus)
                return .binaryOperation(left: node, operation: .plus, right: term())
            } else if token == .operation(.minus) {
                eatOperation(.minus)
                return .binaryOperation(left: node, operation: .minus, right: term())
            }
        }

        return node
    }
}
