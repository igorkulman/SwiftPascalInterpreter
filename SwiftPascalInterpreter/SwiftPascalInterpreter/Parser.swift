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

    /**
     Compares the current token with the given token, if they match, the next token is read, otherwise an error is thrown

     - Parameter token: Expected token
     */
    private func eat(_ token: Token) {
        if currentToken == token {
            currentToken = lexer.getNextToken()
        } else {
            fatalError("Syntax error, expected token, got \(currentToken)")
        }
    }

    /**
     Factor for the grammar described in the `expr` method

     Returns: AST node
     */
    private func factor() -> AST {
        let token = currentToken
        switch token {
        case let .integer(value):
            eat(.integer(value))
            return .number(value)
        case .parenthesis(.left):
            eat(.parenthesis(.left))
            let result = expr()
            eat(.parenthesis(.right))
            return result
        case .operation(.plus):
            eat(.operation(.plus))
            return .unaryOperation(operation: .plus, child: factor())
        case .operation(.minus):
            eat(.operation(.minus))
            return .unaryOperation(operation: .minus, child: factor())
        default:
            fatalError("Syntax error")
        }
    }

    /**
     Term for the grammar described in the `expr` method

     Returns: AST node
     */
    private func term() -> AST {
        var node = factor()

        while [.operation(.mult), .operation(.div)].contains(currentToken) {
            let token = currentToken
            if token == .operation(.mult) {
                eat(.operation(.mult))
                node = .binaryOperation(left: node, operation: .mult, right: factor())
            } else if token == .operation(.div) {
                eat(.operation(.div))
                node = .binaryOperation(left: node, operation: .div, right: factor())
            }
        }

        return node
    }

    /**
     Arithmetic expression parser

     expr   : term (PLUS | MINUS) term)*
     term   : factor ((MUL | DIV) factor)*
     factor : (PLUS | MINUS) factor | INTEGER | LPAREN factor RPAREN

     Returns: AST node
     */
    public func expr() -> AST {

        var node = term()

        while [.operation(.plus), .operation(.minus)].contains(currentToken) {
            let token = currentToken
            if token == .operation(.plus) {
                eat(.operation(.plus))
                node = .binaryOperation(left: node, operation: .plus, right: term())
            } else if token == .operation(.minus) {
                eat(.operation(.minus))
                node = .binaryOperation(left: node, operation: .minus, right: term())
            }
        }

        return node
    }
}
