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

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testIntegerTimesInteger() {
        let lexer = Lexer("3*4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.mult))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testFloatDivideInteger() {
        let lexer = Lexer("3/4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.floatDiv))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testIntegerDivideInteger() {
        let lexer = Lexer("3 DIV 4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.integerDiv))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testMinusPlusInteger() {
        let lexer = Lexer("3 -4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.minus))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace1() {
        let lexer = Lexer("3 +4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace2() {
        let lexer = Lexer("3 + 4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace3() {
        let lexer = Lexer(" 3 + 4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace4() {
        let lexer = Lexer("3+ 4 ")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(3)))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .constant(.integer(4)))
        XCTAssert(eof == .eof)
    }

    func testMultiDigitStrings() {
        let lexer = Lexer(" 13+ 154 ")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .constant(.integer(13)))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .constant(.integer(154)))
        XCTAssert(eof == .eof)
    }

    func testParentheses() {
        let lexer = Lexer("(1+(3*5))")

        XCTAssert(lexer.getNextToken() == .parenthesis(.left))
        XCTAssert(lexer.getNextToken() == .constant(.integer(1)))
        XCTAssert(lexer.getNextToken() == .operation(.plus))
        XCTAssert(lexer.getNextToken() == .parenthesis(.left))
        XCTAssert(lexer.getNextToken() == .constant(.integer(3)))
        XCTAssert(lexer.getNextToken() == .operation(.mult))
        XCTAssert(lexer.getNextToken() == .constant(.integer(5)))
        XCTAssert(lexer.getNextToken() == .parenthesis(.right))
        XCTAssert(lexer.getNextToken() == .parenthesis(.right))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testUnaryOperators() {
        let lexer = Lexer("5 - - - 2")

        XCTAssert(lexer.getNextToken() == .constant(.integer(5)))
        XCTAssert(lexer.getNextToken() == .operation(.minus))
        XCTAssert(lexer.getNextToken() == .operation(.minus))
        XCTAssert(lexer.getNextToken() == .operation(.minus))
        XCTAssert(lexer.getNextToken() == .constant(.integer(2)))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testPascalStructure() {
        let lexer = Lexer("BEGIN a := 2; END.")

        XCTAssert(lexer.getNextToken() == .begin)
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.integer(2)))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .end)
        XCTAssert(lexer.getNextToken() == .dot)
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testComment() {
        let lexer = Lexer("{ a := 5 }")
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testAssignmentAndComment() {
        let lexer = Lexer("a := 2 { a := 5 }")
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.integer(2)))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testCommentAndAssignment() {
        let lexer = Lexer(" { a := 5 }  a := 2  ")
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.integer(2)))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testEmptyPascalProgram() {
        let program =
            """
            PROGRAM Part10AST;
            BEGIN {Part10AST}
            END.  {Part10AST}
            """

        let lexer = Lexer(program)
        XCTAssert(lexer.getNextToken() == .program)
        XCTAssert(lexer.getNextToken() == .id("Part10AST"))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .begin)
        XCTAssert(lexer.getNextToken() == .end)
        XCTAssert(lexer.getNextToken() == .dot)
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testPascalProgram() {
        let program =
            """
            PROGRAM Part10AST;
            VAR
            a, b : INTEGER;

            BEGIN {Part10AST}
            a := 2;
            END.  {Part10AST}
            """

        let lexer = Lexer(program)
        XCTAssert(lexer.getNextToken() == .program)
        XCTAssert(lexer.getNextToken() == .id("Part10AST"))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .varDef)
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .coma)
        XCTAssert(lexer.getNextToken() == .id("b"))
        XCTAssert(lexer.getNextToken() == .colon)
        XCTAssert(lexer.getNextToken() == .integer)
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .begin)
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.integer(2)))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .end)
        XCTAssert(lexer.getNextToken() == .dot)
        XCTAssert(lexer.getNextToken() == .eof)
    }
}
