//
//  TokenizerTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import PascalInterpreter
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

    func testTypesAndConstants() {
        let lexer = Lexer(" a: INTEGER, b: REAL, a:= 2, b:= 3.14 ")
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .colon)
        XCTAssert(lexer.getNextToken() == .type(.integer))
        XCTAssert(lexer.getNextToken() == .coma)
        XCTAssert(lexer.getNextToken() == .id("b"))
        XCTAssert(lexer.getNextToken() == .colon)
        XCTAssert(lexer.getNextToken() == .type(.real))
        XCTAssert(lexer.getNextToken() == .coma)
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.integer(2)))
        XCTAssert(lexer.getNextToken() == .coma)
        XCTAssert(lexer.getNextToken() == .id("b"))
        XCTAssert(lexer.getNextToken() == .assign)
        if case let .constant(.real(value)) = lexer.getNextToken() {
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
        XCTAssert(lexer.getNextToken() == .type(.integer))
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

    func testPascalProgramWithProcedure() {
        let program =
            """
            PROGRAM Part10AST;
            VAR
            a, b : INTEGER;

            PROCEDURE P1;
            BEGIN {P1}

            END;  {P1}

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
        XCTAssert(lexer.getNextToken() == .type(.integer))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .procedure)
        XCTAssert(lexer.getNextToken() == .id("P1"))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .begin)
        XCTAssert(lexer.getNextToken() == .end)
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

    func testMixedCasePascalProgram() {
        let program =
            """
            Program Part10AST;
            Var
            a, b : Integer;

            beGIN {Part10AST}
            a := 2;
            End.  {Part10AST}
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
        XCTAssert(lexer.getNextToken() == .type(.integer))
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

    func testParsingError() {
        let lexer = Lexer("8 + |")
        XCTAssert(lexer.getNextToken() == .constant(.integer(8)))
        XCTAssert(lexer.getNextToken() == .operation(.plus))
        expectFatalError(expectedMessage: "Unrecognized character | at position 4") {
            _ = lexer.getNextToken()
        }
    }

    func testIfElseConditions() {
        let lexer = Lexer("if x = 5 then y:=2 else y:= 8")
        XCTAssert(lexer.getNextToken() == .if)
        XCTAssert(lexer.getNextToken() == .id("x"))
        XCTAssert(lexer.getNextToken() == .equals)
        XCTAssert(lexer.getNextToken() == .constant(.integer(5)))
        XCTAssert(lexer.getNextToken() == .then)
        XCTAssert(lexer.getNextToken() == .id("y"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.integer(2)))
        XCTAssert(lexer.getNextToken() == .else)
        XCTAssert(lexer.getNextToken() == .id("y"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.integer(8)))
    }

    func testComparisons() {
        let lexer = Lexer("x = 5; a <4; 5 > 8")
        XCTAssert(lexer.getNextToken() == .id("x"))
        XCTAssert(lexer.getNextToken() == .equals)
        XCTAssert(lexer.getNextToken() == .constant(.integer(5)))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .lessThan)
        XCTAssert(lexer.getNextToken() == .constant(.integer(4)))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .constant(.integer(5)))
        XCTAssert(lexer.getNextToken() == .greaterThan)
        XCTAssert(lexer.getNextToken() == .constant(.integer(8)))
        XCTAssert(lexer.getNextToken() == .eof)
    }

    func testDataTypes() {
        let lexer = Lexer("a: Integer; b: Real; c: Boolean; c:= true; c:=false; d:= 'Test string'")
        XCTAssert(lexer.getNextToken() == .id("a"))
        XCTAssert(lexer.getNextToken() == .colon)
        XCTAssert(lexer.getNextToken() == .type(.integer))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .id("b"))
        XCTAssert(lexer.getNextToken() == .colon)
        XCTAssert(lexer.getNextToken() == .type(.real))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .id("c"))
        XCTAssert(lexer.getNextToken() == .colon)
        XCTAssert(lexer.getNextToken() == .type(.boolean))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .id("c"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.boolean(true)))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .id("c"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.boolean(false)))
        XCTAssert(lexer.getNextToken() == .semi)
        XCTAssert(lexer.getNextToken() == .id("d"))
        XCTAssert(lexer.getNextToken() == .assign)
        XCTAssert(lexer.getNextToken() == .constant(.string("Test string")))
        XCTAssert(lexer.getNextToken() == .eof)
    }
}
