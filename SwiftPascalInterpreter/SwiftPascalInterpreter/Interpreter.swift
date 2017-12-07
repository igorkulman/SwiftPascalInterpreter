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
    private var currentToken: Token?
    
    public init(_ text: String) {
        lexer = Lexer(text)
    }
    
    private func eatInteger() -> Int {
        switch currentToken! {
        case .integer(let value):
            currentToken = lexer.getNextToken()
            return value
        default:
            fatalError("Expected integer, got \(currentToken!)")
        }
    }
    
    private func eatOperation() -> Operation {
        switch currentToken! {
        case .operation(let operation):
            currentToken = lexer.getNextToken()
            return operation
        default:
            fatalError("Expected plus, got \(currentToken!)")
        }
    }
    
    func term() -> Int {
        return eatInteger()
    }
    
    public func expr() -> Int {
        // start with the first token
        currentToken = lexer.getNextToken()
        
        var result = term()
        
        while let token = currentToken {
            switch token {
            case .operation(let operation):
                eatOperation()
                switch operation {
                case .plus:
                    result = result + term()
                    break
                case .minus:
                    result = result - term()
                    break
                case .mult:
                    result = result * term()
                    break
                case .div:
                    result = result / term()
                    break
                }
                break
            case .eof:
                return result
            default:
                fatalError("Syntax error")
            }
        }
        
        fatalError("Syntax error")
        
       /* // current token should be a single digit number
        let left = eatInteger()
         
        // next token should be the + operation
        let operation = eatOperation()
         
        // last token should be the second single digit number
        let right = eatInteger()
         
        switch operation {
        case .plus:
            return left + right
        case .minus:
            return left - right
        case .times:
            return left * right
        case .divided:
            return left / right
        }*/
    }
}
