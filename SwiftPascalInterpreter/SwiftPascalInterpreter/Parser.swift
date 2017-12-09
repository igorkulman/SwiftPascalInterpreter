//
//  Parser.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 07/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class Parser {

    // MARK: - Fields

    private let lexer: Lexer
    private var currentToken: Token

    public init(_ text: String) {
        lexer = Lexer(text)
        currentToken = lexer.getNextToken()
    }

    // MARK: - Helpers

    /**
     Compares the current token with the given token, if they match, the next token is read,
     otherwise an error is thrown

     - Parameter token: Expected token
     */
    private func eat(_ token: Token) {
        if currentToken == token {
            currentToken = lexer.getNextToken()
        } else {
            fatalError("Syntax error, expected \(token), got \(currentToken)")
        }
    }

    // MARK: - Grammar rules

    /**
     Rule:

     program : PROGRAM variable SEMI block DOT
     */
    private func program() -> AST {
        eat(.program)
        guard case let .id(name) = currentToken else {
            fatalError("Program must have a name")
        }
        eat(.id(name))
        eat(.semi)
        let blockNode = block()
        let programNode = AST.program(name: name, block: blockNode)
        eat(.dot)
        return programNode
    }

    /**
     block : declarations compound_statement
     */
    private func block() -> AST {
        let decs = declarations()
        let statement = compoundStatement()
        return .block(declarations: decs, compound: statement)
    }

    /**
     declarations : VAR (variable_declaration SEMI)+
     | empty
     */
    private func declarations() -> [AST] {
        var declarations: [AST] = []

        if currentToken == .varDef {
            eat(.varDef)
            while case .id = currentToken {
                let declaration = variableDeclaration()
                declarations.append(contentsOf: declaration)
                eat(.semi)
            }
        }

        return declarations
    }

    /**
     variable_declaration : ID (COMMA ID)* COLON type_spec
     */
    private func variableDeclaration() -> [AST] {
        guard case let .id(name) = currentToken else {
            fatalError()
        }

        var variableNames = [name]
        eat(.id(name))

        while currentToken == .coma {
            eat(.coma)
            if case let .id(value) = currentToken {
                variableNames.append(value)
                eat(.id(value))
            } else {
                fatalError("Variable name expected, got \(currentToken)")
            }
        }

        eat(.colon)

        let type = typeSpec()
        return variableNames.map({ .variableDeclaration(name: .variable($0), type: type) })
    }

    /**
     type_spec : INTEGER
     | REAL
     */
    private func typeSpec() -> AST {
        switch currentToken {
        case .integer:
            eat(.integer)
            return .type(.integer)
        case .real:
            eat(.real)
            return .type(.real)
        default:
            fatalError("Expected type, got \(currentToken)")
        }
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
     An empty production
     */
    private func empty() -> AST {
        return .noOp
    }

    /**
     Rule:

     expr: term ((PLUS | MINUS) term)*
     */
    private func expr() -> AST {

        var node = term()

        while [.plus, .minus].contains(currentToken) {
            let token = currentToken
            if token == .plus {
                eat(.plus)
                node = .binaryOperation(left: node, operation: .plus, right: term())
            } else if token == .minus {
                eat(.minus)
                node = .binaryOperation(left: node, operation: .minus, right: term())
            }
        }

        return node
    }

    /**
     Rule:

     term : factor ((MUL | INTEGER_DIV | FLOAT_DIV) factor)*
     */
    private func term() -> AST {
        var node = factor()

        while [.mult, .integerDiv, .floatDiv].contains(currentToken) {
            let token = currentToken
            if token == .mult {
                eat(.mult)
                node = .binaryOperation(left: node, operation: .mult, right: factor())
            } else if token == .integerDiv {
                eat(.integerDiv)
                node = .binaryOperation(left: node, operation: .integerDiv, right: factor())
            } else if token == .floatDiv {
                eat(.floatDiv)
                node = .binaryOperation(left: node, operation: .floatDiv, right: factor())
            }
        }

        return node
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
     Rule:

     factor : PLUS factor
     | MINUS factor
     | INTEGER_CONST
     | REAL_CONST
     | LPAREN expr RPAREN
     | variable
     */
    private func factor() -> AST {
        let token = currentToken
        switch token {
        case .plus:
            eat(.plus)
            return .unaryOperation(operation: .plus, child: factor())
        case .minus:
            eat(.minus)
            return .unaryOperation(operation: .minus, child: factor())
        case let .integerConst(value):
            eat(.integerConst(value))
            return .number(value)
        case let .realConst(value):
            eat(.realConst(value))
            return .number(Int(value.rounded(.toNearestOrEven))) //TODO: proper real types
        case .lparen:
            eat(.lparen)
            let result = expr()
            eat(.rparen)
            return result
        default:
            return variable()
        }
    }

    // MARK: - Public methods.

    /**
     Parser for the following grammar

     program : PROGRAM variable SEMI block DOT

     block : declarations compound_statement

     declarations : VAR (variable_declaration SEMI)+
     | empty

     variable_declaration : ID (COMMA ID)* COLON type_spec

     type_spec : INTEGER

     compound_statement : BEGIN statement_list END

     statement_list : statement
     | statement SEMI statement_list

     statement : compound_statement
     | assignment_statement
     | empty

     assignment_statement : variable ASSIGN expr

     empty :

     expr : term ((PLUS | MINUS) term)*

     term : factor ((MUL | INTEGER_DIV | FLOAT_DIV) factor)*

     factor : PLUS factor
     | MINUS factor
     | INTEGER_CONST
     | REAL_CONST
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
