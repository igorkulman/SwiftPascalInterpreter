//
//  Interpreter.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class Interpreter {
    private let text: String
    private var currentPosition: Int
    private var currentToken: Token?
    private var currentCharacter: Character?
    
    public init(_ text: String) {
        self.text = text
        currentPosition = 0
        currentCharacter = text.isEmpty ? nil : text[text.startIndex]
    }
    
    /**
     Skips all the whitespace
     */
    private func skipWhitestace() {
        while let character = currentCharacter, CharacterSet.whitespaces.contains(character.unicodeScalars.first!) {
            advance()
        }
    }
    
    /**
     Advances by one character forward, sets the current character (if still any available)
     */
    private func advance() {
        currentPosition = currentPosition + 1
        guard currentPosition < text.count else {
            currentCharacter = nil
            return
        }
        
        currentCharacter = text[text.index(text.startIndex, offsetBy: currentPosition)]
    }
    
    /**
     Basic lexical analyzer converting program text into token, reads the text at current position and returns next token
     
     - Returns: Next token in text
     */
    public func getNextToken() -> Token {
        
        // first skip all the whitespace
        skipWhitestace()
        
        // current position in text must be within the text, otherwise it is the end of input
        guard let currentCharacter = currentCharacter else {
            return .eof
        }
        
        // if the character is a digit, convert it to int, create an integer token and move position
        if CharacterSet.decimalDigits.contains(currentCharacter.unicodeScalars.first!) {
            advance()
            return .integer(currentCharacter.int)
        }
        
        if currentCharacter == "+" {
            advance()
            return .operation(.plus)
        }
        
        if currentCharacter == "-" {
            advance()
            return .operation(.minus)
        }
        
        if currentCharacter == "*" {
            advance()
            return .operation(.times)
        }
        
        if currentCharacter == "/" {
            advance()
            return .operation(.divided)
        }
        
        fatalError("Error parsing input")
    }
    
    func eatInteger() -> Int {
        switch currentToken! {
        case .integer(let value):
            currentToken = getNextToken()
            return value
        default:
            fatalError("Expected integer, got \(currentToken!)")
        }
    }
    
    func eatOperation() -> Operation {
        switch currentToken! {
        case .operation(let operation):
            currentToken = getNextToken()
            return operation
        default:
            fatalError("Expected plus, got \(currentToken!)")
        }
    }
    
    public func expr() -> Int {
        // start with teh frist token
        currentToken = getNextToken()
        
        // current token should be a single digit number
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
        }
    }
}
