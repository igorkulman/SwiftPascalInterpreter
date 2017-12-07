//
//  Lexer.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 07/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

/**
 Basic lexical analyzer converting program text into tokens
 */
public class Lexer {
    private let text: String
    private var currentPosition: Int
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
     Reads the text at current position and returns next token
     
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
            return getInteger()
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
            return .operation(.mult)
        }
        
        if currentCharacter == "/" {
            advance()
            return .operation(.div)
        }
        
        fatalError("Error parsing input")
    }
    
    /**
     Reads a possible multidigit integer starting at the current position
     */
    private func getInteger() -> Token {
        var lexem = ""
        while let character = currentCharacter, CharacterSet.alphanumerics.contains(character.unicodeScalars.first!) {
            lexem = lexem + String(character)
            advance()
        }
        return .integer(Int(lexem)!)
    }
}
