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

    private var tokenIndex = 0
    private let tokens: [Token]

    private var currentToken: Token {
        return tokens[tokenIndex]
    }

    private var nextToken: Token {
        return tokens[tokenIndex + 1]
    }

    public init(_ text: String) {
        let lexer = Lexer(text)
        var token = lexer.getNextToken()
        var all = [token]
        while token != .eof {
            token = lexer.getNextToken()
            all.append(token)
        }
        tokens = all
    }

    // MARK: - Helpers

    /**
     Compares the current token with the given token, if they match, the next token is read,
     otherwise an error is thrown

     - Parameter token: Expected token
     */
    private func eat(_ token: Token) {
        if currentToken == token {
            tokenIndex += 1
        } else {
            fatalError("Syntax error, expected \(token), got \(currentToken)")
        }
    }

    // MARK: - Grammar rules

    /**
     Rule:

     program : PROGRAM variable SEMI block DOT
     */
    private func program() -> Program {
        eat(.program)
        guard case let .id(name) = currentToken else {
            fatalError("Program must have a name")
        }
        eat(.id(name))
        eat(.semi)
        let blockNode = block()
        let programNode = Program(name: name, block: blockNode)
        eat(.dot)
        return programNode
    }

    /**
     block : declarations compound_statement
     */
    private func block() -> Block {
        let decs = declarations()
        let statement = compoundStatement()
        return Block(declarations: decs, compound: statement)
    }

    /**
     declarations : VAR (variable_declaration SEMI)+
     | (PROCEDURE ID (LPAREN formal_parameter_list RPAREN)? SEMI block SEMI)*
     | (FUNCTION ID (LPAREN formal_parameter_list RPAREN)? COLON type_spec SEMI block SEMI)*
     | empty
     */
    private func declarations() -> [Declaration] {
        var declarations: [Declaration] = []

        if currentToken == .varDef {
            eat(.varDef)
            while case .id = currentToken {
                let decs = variableDeclaration()
                for declaration in decs {
                    declarations.append(declaration)
                }
                eat(.semi)
            }
        }

        while currentToken == .procedure {
            eat(.procedure)
            guard case let .id(name) = currentToken else {
                fatalError("Procedure name expected, got \(currentToken)")
            }
            eat(.id(name))

            var params: [Param] = []
            if currentToken == .parenthesis(.left) {
                eat(.parenthesis(.left))
                params = formalParameterList()
                eat(.parenthesis(.right))
            }

            eat(.semi)
            let body = block()
            let procedure = Procedure(name: name, params: params, block: body)
            declarations.append(procedure)
            eat(.semi)
        }

        while currentToken == .function {
            eat(.function)
            guard case let .id(name) = currentToken else {
                fatalError("Function name expected, got \(currentToken)")
            }
            eat(.id(name))

            var params: [Param] = []
            if currentToken == .parenthesis(.left) {
                eat(.parenthesis(.left))
                params = formalParameterList()
                eat(.parenthesis(.right))
            }

            eat(.colon)
            let type = typeSpec()

            eat(.semi)
            let body = block()
            let function = Function(name: name, params: params, block: body, returnType: type)
            declarations.append(function)
            eat(.semi)
        }

        return declarations
    }

    /**
     formal_parameter_list : formal_parameters
     | formal_parameters SEMI formal_parameter_list
     */
    private func formalParameterList() -> [Param] {
        guard case .id = currentToken else {
            return [] // procedure without parameters
        }

        var parameters = formalParameters()
        while currentToken == .semi {
            eat(.semi)
            parameters.append(contentsOf: formalParameterList())
        }
        return parameters
    }

    /**
     formal_parameters : ID (COMMA ID)* COLON type_spec
     */
    private func formalParameters() -> [Param] {
        guard case let .id(name) = currentToken else {
            fatalError("Parameter name expected, got \(currentToken)")
        }

        var parameters = [name]

        eat(.id(name))
        while currentToken == .coma {
            eat(.coma)
            guard case let .id(name) = currentToken else {
                fatalError("Parameter name expected, got \(currentToken)")
            }
            eat(.id(name))
            parameters.append(name)
        }

        eat(.colon)
        let type = typeSpec()
        return parameters.map({ Param(name: $0, type: type) })
    }

    /**
     variable_declaration : ID (COMMA ID)* COLON type_spec
     */
    private func variableDeclaration() -> [VariableDeclaration] {
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
        return variableNames.map({ VariableDeclaration(variable: Variable(name: $0), type: type) })
    }

    /**
     type_spec : INTEGER
     | REAL
     */
    private func typeSpec() -> VariableType {
        switch currentToken {
        case .type(.integer):
            eat(.type(.integer))
            return VariableType(type: .integer)
        case .type(.real):
            eat(.type(.real))
            return VariableType(type: .real)
        case .type(.boolean):
            eat(.type(.boolean))
            return VariableType(type: .boolean)
        case .type(.string):
            eat(.type(.string))
            return VariableType(type: .string)
        default:
            fatalError("Expected type, got \(currentToken)")
        }
    }

    /**
     Rule:

     compound_statement: BEGIN statement_list END
     */
    private func compoundStatement() -> Compound {
        eat(.begin)
        let nodes = statementList()
        eat(.end)
        return Compound(children: nodes)
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
     | procedure_call
     | if_else_statement
     | assignment_statement
     | repeat_until
     | for_loop
     | while_loop
     | empty
     */
    private func statement() -> AST {
        switch currentToken {
        case .begin:
            return compoundStatement()
        case .if:
            return ifElseStatement()
        case .repeat:
            return repeatUntilLoop()
        case .while:
            return whileLoop()
        case .for:
            return forLoop()
        case .id:
            if nextToken == .parenthesis(.left) {
                return functionCall()
            } else {
                return assignmentStatement()
            }
        default:
            return empty()
        }
    }

    /**
     Rule:

     repeat_until : REPEAT statement UNTIL condition
     */
    private func repeatUntilLoop() -> RepeatUntil {
        eat(.repeat)

        var statements: [AST] = []

        while currentToken != .until {
            statements.append(statement())
            if currentToken == .semi {
                eat(.semi)
            }
        }
        eat(.until)
        let condition = self.condition()
        return RepeatUntil(statement: statements.count == 1 ? statements[0] : Compound(children: statements), condition: condition)
    }

    /**
     Rule:

     for_loop : WHILE condition DO statement
     */
    private func whileLoop() -> While {
        eat(.while)
        let condition = self.condition()
        eat(.do)
        let statement = self.statement()
        return While(statement: statement, condition: condition)
    }

    /**
     Rule:

     for_loop : FOR variable ASSIGN expression TO expression DO statement
     */
    private func forLoop() -> For {
        eat(.for)
        let variable = self.variable()
        eat(.assign)
        let start = expr()
        eat(.to)
        let end = expr()
        eat(.do)
        let statement = self.statement()
        return For(statement: statement, variable: variable, startValue: start, endValue: end)
    }

    /**
     Rule:

     function_call : id LPAREN (factor (factor COLON)* )* RPAREN
     */
    private func functionCall() -> FunctionCall {
        guard case let .id(name) = currentToken else {
            fatalError("Procedure name expected, got \(currentToken)")
        }

        var parameters: [AST] = []

        eat(.id(name))
        eat(.parenthesis(.left))
        if currentToken == .parenthesis(.right) { // no parameters
            eat(.parenthesis(.right))
        } else {
            parameters.append(expr())
            while currentToken == .coma {
                eat(.coma)
                parameters.append(factor())
            }
            eat(.parenthesis(.right))
        }

        return FunctionCall(name: name, actualParameters: parameters)
    }

    /**
     Rule:

     if_else_statement : IF condition statement
     | IF condition THEN statement ELSE statement
     */
    private func ifElseStatement() -> IfElse {
        eat(.if)
        let cond = condition()
        eat(.then)
        let trueStatement = statement()
        var falseStatement: AST?
        if currentToken == .else {
            eat(.else)
            falseStatement = statement()
        }

        return IfElse(condition: cond, trueExpression: trueStatement, falseExpression: falseStatement)
    }

    /**
     Rule:
     condition: expr (= | < | >) expr
     | LPAREN expr (= | < | >) expr RPAREN
     */
    private func condition() -> Condition {
        if currentToken == .parenthesis(.left) {
            eat(.parenthesis(.left))
        }
        let left = expr()
        var type: ConditionType = .equals
        switch currentToken {
        case .equals:
            eat(.equals)
            type = .equals
        case .lessThan:
            eat(.lessThan)
            type = .lessThan
        case .greaterThan:
            eat(.greaterThan)
            type = .greaterThan
        default:
            fatalError("Invalid condition type \(type)")
        }
        let right = expr()
        if currentToken == .parenthesis(.right) {
            eat(.parenthesis(.right))
        }
        return Condition(type: type, leftSide: left, rightSide: right)
    }

    /**
     Rule:

     assignment_statement : variable ASSIGN expr
     */
    private func assignmentStatement() -> Assignment {
        let left = variable()
        eat(.assign)
        let right = expr()
        return Assignment(left: left, right: right)
    }

    /**
     An empty production
     */
    private func empty() -> NoOp {
        return NoOp()
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
                node = BinaryOperation(left: node, operation: .plus, right: term())
            } else if token == .operation(.minus) {
                eat(.operation(.minus))
                node = BinaryOperation(left: node, operation: .minus, right: term())
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

        while [.operation(.mult), .operation(.integerDiv), .operation(.floatDiv)].contains(currentToken) {
            let token = currentToken
            if token == .operation(.mult) {
                eat(.operation(.mult))
                node = BinaryOperation(left: node, operation: .mult, right: factor())
            } else if token == .operation(.integerDiv) {
                eat(.operation(.integerDiv))
                node = BinaryOperation(left: node, operation: .integerDiv, right: factor())
            } else if token == .operation(.floatDiv) {
                eat(.operation(.floatDiv))
                node = BinaryOperation(left: node, operation: .floatDiv, right: factor())
            }
        }

        return node
    }

    /**
     Rule:

     variable : ID
     */
    private func variable() -> Variable {
        switch currentToken {
        case let .id(value):
            eat(.id(value))
            return Variable(name: value)
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
     | STRING_CONST
     | LPAREN expr RPAREN
     | variable
     | function_call
     */
    private func factor() -> AST {
        let token = currentToken
        switch token {
        case .operation(.plus):
            eat(.operation(.plus))
            return UnaryOperation(operation: .plus, operand: factor())
        case .operation(.minus):
            eat(.operation(.minus))
            return UnaryOperation(operation: .minus, operand: factor())
        case let .constant(.integer(value)):
            eat(.constant(.integer(value)))
            return Number.integer(value)
        case let .constant(.real(value)):
            eat(.constant(.real(value)))
            return Number.real(value)
        case .parenthesis(.left):
            eat(.parenthesis(.left))
            let result = expr()
            eat(.parenthesis(.right))
            return result
        case let .constant(.string(value)):
            eat(.constant(.string(value)))
            return value
        case let .constant(.boolean(value)):
            eat(.constant(.boolean(value)))
            return value
        default:
            if nextToken == .parenthesis(.left) {
                return functionCall()
            } else {
                return variable()
            }
        }
    }

    // MARK: - Public methods.

    /**
     Parser for the following grammar

     program : PROGRAM variable SEMI block DOT

     block : declarations compound_statement

     declarations : (VAR (variable_declaration SEMI)+)*
     | (PROCEDURE ID (LPAREN formal_parameter_list RPAREN)? SEMI block SEMI)*
     | empty

     formal_parameter_list : formal_parameters
     | formal_parameters SEMI formal_parameter_list

     formal_parameters : ID (COMMA ID)* COLON type_spec

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
