//
//  TokenizerTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftPascalInterpreter

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
}
