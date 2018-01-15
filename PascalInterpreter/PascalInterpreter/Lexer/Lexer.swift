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

    // MARK: - Fields

    private let text: String
    private var currentPosition: Int
    private var currentCharacter: Character?
    private var isStringStart = false
    private var wasStringLast = false

    // MARK: - Constants

    private let keywords: [String: Token] = [
        "PROGRAM": .program,
        "VAR": .varDef,
        "DIV": .operation(.integerDiv),
        "INTEGER": .type(.integer),
        "REAL": .type(.real),
        "BOOLEAN": .type(.boolean),
        "STRING": .type(.string),
        "BEGIN": .begin,
        "END": .end,
        "PROCEDURE": .procedure,
        "TRUE": .constant(.boolean(true)),
        "FALSE": .constant(.boolean(false)),
        "IF": .if,
        "ELSE": .else,
        "THEN": .then,
        "FUNCTION": .function,
        "REPEAT": .repeat,
        "UNTIL": .until,
        "FOR": .for,
        "TO": .to,
        "DO": .do,
        "WHILE": .while,
        "OF": .of,
        "ARRAY": .array
    ]

    public init(_ text: String) {
        self.text = text
        currentPosition = 0
        currentCharacter = text.isEmpty ? nil : text[text.startIndex]
    }

    // MARK: - Stream helpers

    /**
     Skips all the whitespace
     */
    private func skipWhitestace() {
        while let character = currentCharacter, CharacterSet.whitespacesAndNewlines.contains(character.unicodeScalars.first!) {
            advance()
        }
    }

    /**
     Skips all the commented text
     */
    private func skipComments() {
        while let character = currentCharacter, character != "}" {
            advance()
        }
        advance() // closing bracket
    }

    /**
     Advances by one character forward, sets the current character (if still any available)
     */
    private func advance() {
        currentPosition += 1
        guard currentPosition < text.count else {
            currentCharacter = nil
            return
        }

        currentCharacter = text[text.index(text.startIndex, offsetBy: currentPosition)]
    }

    /**
     Returns the next character without advancing

     Returns: Character if not at the end of the text, nil otherwise
     */
    private func peek() -> Character? {
        let peekPosition = currentPosition + 1

        guard peekPosition < text.count else {
            return nil
        }

        return text[text.index(text.startIndex, offsetBy: peekPosition)]
    }

    // MARK: - Parsing helpers

    /**
     Reads a possible multidigit integer starting at the current position
     */
    private func number() -> Token {
        var lexem = ""
        while let character = currentCharacter, CharacterSet.decimalDigits.contains(character.unicodeScalars.first!) {
            lexem += String(character)
            advance()
        }

        if let character = currentCharacter, character == ".", text[text.index(text.startIndex, offsetBy: currentPosition + 1)] != "." {
            lexem += "."
            advance()

            while let character = currentCharacter, CharacterSet.decimalDigits.contains(character.unicodeScalars.first!) {
                lexem += String(character)
                advance()
            }

            return .constant(.real(Double(lexem)!))
        }

        return .constant(.integer(Int(lexem)!))
    }

    /**
     Handles identifies and reserved keywords

     Returns: Token
     */
    private func id() -> Token {
        var lexem = ""
        while let character = currentCharacter, CharacterSet.alphanumerics.contains(character.unicodeScalars.first!) {
            lexem += String(character)
            advance()
        }

        if let token = keywords[lexem.uppercased()] {
            return token
        }

        return .id(lexem)
    }

    private func string() -> Token {
        var lexem = ""
        while let character = currentCharacter, character != "'" {
            lexem += String(character)
            advance()
        }
        return .constant(.string(lexem))
    }

    // MARK: - Public methods

    /**
     Reads the text at current position and returns next token

     - Returns: Next token in text
     */
    public func getNextToken() -> Token {

        while let currentCharacter = currentCharacter {

            if wasStringLast {
                wasStringLast = false
                if currentCharacter == "'" {
                    advance()
                }
                return .apostrophe
            }

            if isStringStart {
                wasStringLast = true
                isStringStart = false
                return string()
            }

            if CharacterSet.whitespacesAndNewlines.contains(currentCharacter.unicodeScalars.first!) {
                skipWhitestace()
                continue
            }

            if currentCharacter == "{" {
                advance()
                skipComments()
                continue
            }

            if currentCharacter == "'" {
                advance()
                isStringStart = !isStringStart
                return .apostrophe
            }

            // if the character is a digit, convert it to int, create an integer token and move position
            if CharacterSet.decimalDigits.contains(currentCharacter.unicodeScalars.first!) {
                return number()
            }

            if CharacterSet.alphanumerics.contains(currentCharacter.unicodeScalars.first!) {
                return id()
            }

            if currentCharacter == ":" && peek() == "=" {
                advance()
                advance()
                return .assign
            }

            if currentCharacter == "." {
                advance()
                return .dot
            }

            if currentCharacter == "," {
                advance()
                return .coma
            }

            if currentCharacter == ";" {
                advance()
                return .semi
            }

            if currentCharacter == ":" {
                advance()
                return .colon
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
                return .operation(.floatDiv)
            }

            if currentCharacter == "(" {
                advance()
                return .parenthesis(.left)
            }

            if currentCharacter == ")" {
                advance()
                return .parenthesis(.right)
            }

            if currentCharacter == "[" {
                advance()
                return .bracket(.left)
            }

            if currentCharacter == "]" {
                advance()
                return .bracket(.right)
            }

            if currentCharacter == "=" {
                advance()
                return .equals
            }

            if currentCharacter == ">" {
                advance()
                return .greaterThan
            }

            if currentCharacter == "<" {
                advance()
                return .lessThan
            }

            fatalError("Unrecognized character \(currentCharacter) at position \(currentPosition)")
        }

        return .eof
    }
}
