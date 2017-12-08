//
//  TokenizerTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import SwiftPascalInterpreter
import XCTest

class LexerTests: XCTestCase {

    func testEmptyInput() {
        let lexer = Lexer("")
        let eof = lexer.getNextToken()
        XCTAssert(eof == .eof)
    }

    func testWhitespaceOnlyInput() {
        let lexer = Lexer(" ")
        let eof = lexer.getNextToken()
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusInteger() {
        let lexer = Lexer("3+4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerTimesInteger() {
        let lexer = Lexer("3*4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.mult))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerDivideInteger() {
        let lexer = Lexer("3/4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.div))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }

    func testMinusPlusInteger() {
        let lexer = Lexer("3 -4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.minus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace1() {
        let lexer = Lexer("3 +4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace2() {
        let lexer = Lexer("3 + 4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace3() {
        let lexer = Lexer(" 3 + 4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace4() {
        let lexer = Lexer("3+ 4 ")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }

    func testMultiDigitStrings() {
        let lexer = Lexer(" 13+ 154 ")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integer(13))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(154))
        XCTAssert(eof == .eof)
    }

    func testParentheses() {
        let lexer = Lexer("(1+(3*5))")

        XCTAssert(lexer.getNextToken() == .parenthesis(.left))
        XCTAssert(lexer.getNextToken() == .integer(1))
        XCTAssert(lexer.getNextToken() == .operation(.plus))
        XCTAssert(lexer.getNextToken() == .parenthesis(.left))
        XCTAssert(lexer.getNextToken() == .integer(3))
        XCTAssert(lexer.getNextToken() == .operation(.mult))
        XCTAssert(lexer.getNextToken() == .integer(5))
        XCTAssert(lexer.getNextToken() == .parenthesis(.right))
        XCTAssert(lexer.getNextToken() == .parenthesis(.right))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testUnaryOperators() {
        let lexer = Lexer("5 - - - 2")

        XCTAssert(lexer.getNextToken() == .integer(5))
        XCTAssert(lexer.getNextToken() == .operation(.minus))
        XCTAssert(lexer.getNextToken() == .operation(.minus))
        XCTAssert(lexer.getNextToken() == .operation(.minus))
        XCTAssert(lexer.getNextToken() == .integer(2))
        XCTAssert(lexer.getNextToken() == .eof)
    }
}
