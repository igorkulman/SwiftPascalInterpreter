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
     Compares the current token with the given token, if they match, the next token is read,
     otherwise an error is thrown

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
     Rule:

     factor : PLUS  factor
     | MINUS factor
     | INTEGER
     | LPAREN expr RPAREN
     | variable
     */
    private func factor() -> AST {
        let token = currentToken
        switch token {
        case .operation(.plus):
            eat(.operation(.plus))
            return .unaryOperation(operation: .plus, child: factor())
        case .operation(.minus):
            eat(.operation(.minus))
            return .unaryOperation(operation: .minus, child: factor())
        case let .integer(value):
            eat(.integer(value))
            return .number(value)
        case .parenthesis(.left):
            eat(.parenthesis(.left))
            let result = expr()
            eat(.parenthesis(.right))
            return result
        default:
            return variable()
        }
    }

    /**
     Rule:

     term: factor ((MUL | DIV) factor)*
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
     Rule:

     expr: term ((PLUS | MINUS) term)*
     */
    private func expr() -> AST {

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

    /**
     Rule:

     program : compound_statement DOT
     */
    private func program() -> AST {
        let node = compoundStatement()
        eat(.dot)
        return node
    }

    /**
     Rule:

     compound_statement: BEGIN statement_list END
     */
    private func compoundStatement() -> AST {
        eat(.begin)
        let nodes = statementList()
        eat(.end)
        return .compound(children: nodes)
    }

    /**
     Rule:

     statement_list : statement
     | statement SEMI statement_list
     */
    private func statementList() -> [AST] {
        let node = statement()

        var statements = [node]

        while currentToken == .semi {
            eat(.semi)
            statements.append(statement())
        }

        return statements
    }

    /**
     Rule:

     statement : compound_statement
     | assignment_statement
     | empty
     */
    private func statement() -> AST {
        switch currentToken {
        case .begin:
            return compoundStatement()
        case .id:
            return assignmentStatement()
        default:
            return empty()
        }
    }

    /**
     Rule:

     assignment_statement : variable ASSIGN expr
     */
    private func assignmentStatement() -> AST {
        let left = variable()
        eat(.assign)
        let right = expr()
        return .assignment(left: left, right: right)
    }

    /**
     Rule:

     variable : ID
     */
    private func variable() -> AST {
        switch currentToken {
        case let .id(value):
            eat(.id(value))
            return .variable(value)
        default:
            fatalError("Syntax error, expected variable, found \(currentToken)")
        }
    }

    /**
     An empty production
     */
    private func empty() -> AST {
        return .noOp
    }

    /**
     Parser for the following grammar

     program : compound_statement DOT

     compound_statement : BEGIN statement_list END

     statement_list : statement
     | statement SEMI statement_list

     statement : compound_statement
     | assignment_statement
     | empty

     assignment_statement : variable ASSIGN expr

     empty :

     expr: term ((PLUS | MINUS) term)*

     term: factor ((MUL | DIV) factor)*

     factor : PLUS factor
     | MINUS factor
     | INTEGER
     | LPAREN expr RPAREN
     | variable

     variable: ID
     */
    public func parse() -> AST {
        let node = program()
        if currentToken != .eof {
            fatalError("Syntax error, end of file expected")
        }

        return node
    }
}
