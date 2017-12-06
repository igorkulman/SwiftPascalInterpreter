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
    private var textPosition: Int = 0
    private var currentToken: Token?
    
    public init(_ text: String) {
        self.text = text
    }
    
    /**
     Basic lexical analyzer converting program text into token, reads the text at current position and returns next token
     
     - Returns: Next token in text
     */
    func getNextToken() -> Token {
        
        // current position in text must be within the text, otherwise it is the end of input
        guard textPosition < text.count else {
            return .eof
        }
        
        // get character at the current text position and decide what token to create
        let index = text.index(text.startIndex, offsetBy: textPosition)
        let currentCharacter = text[index]
        
        // if the character is a digit, convert it to int, create an integer token and move position
        if CharacterSet.decimalDigits.contains(currentCharacter.unicodeScalars.first!) {
            textPosition = textPosition + 1
            return .integer(currentCharacter.int)
        }
        
        // if the character is +, create a plus token and move position
        if currentCharacter == "+" {
            textPosition = textPosition + 1
            return .plus
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
    
    func eatPlus() {
        switch currentToken! {
        case .plus:
            currentToken = getNextToken()
            return
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
        eatPlus()
        
        // last token should be the second single digit number
        let right = eatInteger()
        
        let result = left + right
        return result
    }
}
