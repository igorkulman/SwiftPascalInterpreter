//
//  ParserTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 07/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import PascalInterpreter
import XCTest

class ParserTests: XCTestCase {
    func testBasicCompoundStatement() {
        let program =
            """
            PROGRAM Part10AST;
            BEGIN
                a := 2
            END.
            """

        let a = AST.variable("a")
        let two = AST.number(.integer(2))
        let assignment = AST.assignment(left: a, right: two)
        let block = AST.block(declarations: [], compound: AST.compound(children: [assignment]))
        let node = AST.program(name: "Part10AST", block: block)
        let parser = Parser(program)
        let result = parser.parse()
        XCTAssert(result == node)
    }

    func testMoreComplexExpression() {
        let program =
            """
            PROGRAM Part10AST;
            BEGIN
                BEGIN
                    number := 2;
                    a := number + 2;
                END;
                x := 11;
            END.
            """

        let parser = Parser(program)
        let result = parser.parse()
        let empty = AST.noOp
        let eleven = AST.number(.integer(11))
        let x = AST.variable("x")
        let xAssignment = AST.assignment(left: x, right: eleven)
        let two = AST.number(.integer(2))
        let number = AST.variable("number")
        let a = AST.variable("a")
        let aAssignment = AST.assignment(left: a, right: AST.binaryOperation(left: number, operation: .plus, right: two))
        let compound = AST.compound(children: [AST.assignment(left: number, right: two), aAssignment, empty])
        let block = AST.block(declarations: [], compound: AST.compound(children: [compound, xAssignment, empty]))
        let node = AST.program(name: "Part10AST", block: block)
        XCTAssert(result == node)
    }

    func testEvenMoreComplexExpression() {
        let program =
            """
            PROGRAM Part10AST;
            BEGIN
                BEGIN
                    number := 2;
                    a := number;
                    a := 10 * a + 10 * number / 4;
                END;
                x := 11;
            END.
            """

        let parser = Parser(program)
        let result = parser.parse()
        let empty = AST.noOp
        let eleven = AST.number(.integer(11))
        let x = AST.variable("x")
        let xAssignment = AST.assignment(left: x, right: eleven)
        let two = AST.number(.integer(2))
        let number = AST.variable("number")
        let a = AST.variable("a")
        let division = AST.binaryOperation(left: AST.binaryOperation(left: AST.number(.integer(10)), operation: .mult, right: number), operation: .floatDiv, right: AST.number(.integer(4)))
        let plus = AST.binaryOperation(left: AST.binaryOperation(left: AST.number(.integer(10)), operation: .mult, right: a), operation: .plus, right: division)
        let aAssignment = AST.assignment(left: a, right: plus)
        let compound = AST.compound(children: [AST.assignment(left: number, right: two), AST.assignment(left: a, right: number), aAssignment, empty])
        let node = AST.program(name: "Part10AST", block: AST.block(declarations: [], compound: AST.compound(children: [compound, xAssignment, empty])))
        XCTAssert(result == node)
    }

    func testProgramWithDeclarationsExpression() {
        let program =
            """
            PROGRAM Part10AST;
            VAR
                a, b : INTEGER;
                y    : REAL;
            BEGIN
                BEGIN
                    number := 2;
                    a := number;
                    a := 10 * a + 10 * number / 4;
                END;
                x := 11;
            END.
            """

        let parser = Parser(program)
        let result = parser.parse()
        let empty = AST.noOp
        let eleven = AST.number(.integer(11))
        let x = AST.variable("x")
        let xAssignment = AST.assignment(left: x, right: eleven)
        let two = AST.number(.integer(2))
        let number = AST.variable("number")
        let a = AST.variable("a")
        let division = AST.binaryOperation(left: AST.binaryOperation(left: AST.number(.integer(10)), operation: .mult, right: number), operation: .floatDiv, right: AST.number(.integer(4)))
        let plus = AST.binaryOperation(left: AST.binaryOperation(left: AST.number(.integer(10)), operation: .mult, right: a), operation: .plus, right: division)
        let aAssignment = AST.assignment(left: a, right: plus)
        let compound = AST.compound(children: [AST.assignment(left: number, right: two), AST.assignment(left: a, right: number), aAssignment, empty])
        let aDec = AST.variableDeclaration(name: AST.variable("a"), type: .type(.integer))
        let bDec = AST.variableDeclaration(name: AST.variable("b"), type: .type(.integer))
        let yDec = AST.variableDeclaration(name: AST.variable("y"), type: .type(.real))
        let node = AST.program(name: "Part10AST", block: AST.block(declarations: [aDec, bDec, yDec], compound: AST.compound(children: [compound, xAssignment, empty])))
        XCTAssert(result == node)
    }

    func testBasicCompoundStatementFail() {
        let program =
            """
            PROGRAM Part10AST;
            BEGIN
                a := 2
            END
            """

        let parser = Parser(program)
        expectFatalError(expectedMessage: "Syntax error, expected DOT, got EOF") {
            _ = parser.parse()
        }
    }
}
