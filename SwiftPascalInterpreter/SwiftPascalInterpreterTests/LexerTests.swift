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

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .plus)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerTimesInteger() {
        let lexer = Lexer("3*4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .mult)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testFloatDivideInteger() {
        let lexer = Lexer("3/4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .floatDiv)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerDivideInteger() {
        let lexer = Lexer("3 DIV 4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .integerDiv)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testMinusPlusInteger() {
        let lexer = Lexer("3 -4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .minus)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace1() {
        let lexer = Lexer("3 +4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .plus)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace2() {
        let lexer = Lexer("3 + 4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .plus)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace3() {
        let lexer = Lexer(" 3 + 4")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .plus)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testIntegerPlusIntegerWithWhiteSace4() {
        let lexer = Lexer("3+ 4 ")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(3))
        XCTAssert(operation == .plus)
        XCTAssert(right == .integerConst(4))
        XCTAssert(eof == .eof)
    }

    func testMultiDigitStrings() {
        let lexer = Lexer(" 13+ 154 ")
        let left = lexer.getNextToken()
        let operation = lexer.getNextToken()
        let right = lexer.getNextToken()
        let eof = lexer.getNextToken()

        XCTAssert(left == .integerConst(13))
        XCTAssert(operation == .plus)
        XCTAssert(right == .integerConst(154))
        XCTAssert(eof == .eof)
    }

    func testParentheses() {
        let lexer = Lexer("(1+(3*5))")

        XCTAssert(lexer.getNextToken() == .lparen)
        XCTAssert(lexer.getNextToken() == .integerConst(1))
        XCTAssert(lexer.getNextToken() == .plus)
        XCTAssert(lexer.getNextToken() == .lparen)
        XCTAssert(lexer.getNextToken() == .integerConst(3))
        XCTAssert(lexer.getNextToken() == .mult)
        XCTAssert(lexer.getNextToken() == .integerConst(5))
        XCTAssert(lexer.getNextToken() == .rparen)
        XCTAssert(lexer.getNextToken() == .rparen)
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testUnaryOperators() {
        let lexer = Lexer("5 - - - 2")

        XCTAssert(lexer.getNextToken() == .integerConst(5))
        XCTAssert(lexer.getNextToken() == .minus)
        XCTAssert(lexer.getNextToken() == .minus)
        XCTAssert(lexer.getNextToken() == .minus)
        XCTAssert(lexer.getNextToken() == .integerConst(2))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testPascalStructure() {
        let lexer = Lexer("BEGIN a := 2; END.")

        XCTAssert(lexer.getNextToken() == .begin)
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .integerConst(2))
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
        XCTAssert(lexer.getNextToken() == .integerConst(2))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testCommentAndAssignment() {
        let lexer = Lexer(" { a := 5 }  a := 2  ")
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .integerConst(2))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testTypesAndConstants() {
        let lexer = Lexer(" a: INTEGER, b: REAL, a:= 2, b:= 3.14 ")
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .colon)
        XCTAssert(lexer.getNextToken() == .integer)
        XCTAssert(lexer.getNextToken() == .coma)
        XCTAssert(lexer.getNextToken() == .id("b"))
        XCTAssert(lexer.getNextToken() == .colon)
        XCTAssert(lexer.getNextToken() == .real)
        XCTAssert(lexer.getNextToken() == .coma)
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .integerConst(2))
        XCTAssert(lexer.getNextToken() == .coma)
        XCTAssert(lexer.getNextToken() == .id("b"))
        XCTAssert(lexer.getNextToken() == .assign)
        if case let .realConst(value) = lexer.getNextToken() {
            XCTAssert(abs(3.14 - value) < 0.01)
        } else {
            XCTFail("Given value differes from expected 3.14")
        }
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
        XCTAssert(lexer.getNextToken() == .integerConst(2))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .end)
        XCTAssert(lexer.getNextToken() == .dot)
        XCTAssert(lexer.getNextToken() == .eof)
    }
}
