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

    func testProgramWithProcedure() {
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

        let parser = Parser(program)
        let result = parser.parse()
        let empty = AST.noOp
        let two = AST.number(.integer(2))
        let a = AST.variable("a")
        let compound = AST.compound(children: [AST.assignment(left: a, right: two), empty])
        let aDec = AST.variableDeclaration(name: AST.variable("a"), type: .type(.integer))
        let bDec = AST.variableDeclaration(name: AST.variable("b"), type: .type(.integer))
        let p1 = AST.procedure(name: "P1", params: [], block: AST.block(declarations: [], compound: AST.compound(children: [.noOp])))
        let node = AST.program(name: "Part10AST", block: AST.block(declarations: [aDec, bDec, p1], compound: compound))
        XCTAssert(result == node)
    }

    func testProgramWithNestedProcedures() {
        let program =
            """
            PROGRAM Part12;
            VAR
                a : INTEGER;

            PROCEDURE P1;
            VAR
                a : REAL;
                k : INTEGER;

                PROCEDURE P2;
                VAR
                    a, z : INTEGER;
                BEGIN {P2}
                    z := 777;
                END;  {P2}

            BEGIN {P1}

            END;  {P1}

            BEGIN {Part12}
            a := 10;
            END.  {Part12}
            """

        let parser = Parser(program)
        let result = parser.parse()
        let empty = AST.noOp
        let ten = AST.number(.integer(10))
        let a = AST.variable("a")
        let compound = AST.compound(children: [AST.assignment(left: a, right: ten), empty])
        let aDec = AST.variableDeclaration(name: AST.variable("a"), type: .type(.integer))
        let p2 = AST.procedure(name: "P2", params: [], block: AST.block(declarations: [AST.variableDeclaration(name: .variable("a"), type: .type(.integer)), AST.variableDeclaration(name: .variable("z"), type: .type(.integer))], compound: AST.compound(children: [AST.assignment(left: AST.variable("z"), right: AST.number(.integer(777))), empty])))
        let p1 = AST.procedure(name: "P1", params: [], block: AST.block(declarations: [AST.variableDeclaration(name: .variable("a"), type: .type(.real)), AST.variableDeclaration(name: .variable("k"), type: .type(.integer)), p2], compound: AST.compound(children: [empty])))
        let node = AST.program(name: "Part12", block: AST.block(declarations: [aDec, p1], compound: compound))
        XCTAssert(result == node)
    }

    func testProgramWithProcedureCall() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha();
            begin
            x := 5;
            end;

            begin { Main }
            Alpha();
            y := 5;
            Alpha();
            end.  { Main }
            """

        let parser = Parser(program)
        let result = parser.parse()
        let alpha = AST.procedure(name: "Alpha", params: [], block: AST.block(declarations: [], compound: AST.compound(children: [AST.assignment(left: AST.variable("x"), right: AST.number(.integer(5))), AST.noOp])))
        let xDec = AST.variableDeclaration(name: AST.variable("x"), type: .type(.real))
        let yDec = AST.variableDeclaration(name: AST.variable("y"), type: .type(.real))
        let compound = AST.compound(children: [AST.call(procedureName: "Alpha", params: []), AST.assignment(left: AST.variable("y"), right: AST.number(.integer(5))), AST.call(procedureName: "Alpha", params: []), AST.noOp])
        let node = AST.program(name: "Main", block: AST.block(declarations: [xDec, yDec, alpha], compound: compound))
        XCTAssert(result == node)
    }

    func testProgramWithProcedureCallAndParameters() {
        let program =
        """
            program Main;
            var x, y: real;

            procedure Alpha(a: Integer);
            begin
            x := 5 + a;
            end;

            begin { Main }
            y := 5;
            Alpha(5);
            end.  { Main }
            """

        let parser = Parser(program)
        let result = parser.parse()
        let alpha = AST.procedure(name: "Alpha", params: [AST.param(name: "a", type: AST.type(.integer))], block: AST.block(declarations: [], compound: AST.compound(children: [AST.assignment(left: AST.variable("x"), right: AST.binaryOperation(left: AST.number(.integer(5)), operation: .plus, right: AST.variable("a"))), AST.noOp])))
        let xDec = AST.variableDeclaration(name: AST.variable("x"), type: .type(.real))
        let yDec = AST.variableDeclaration(name: AST.variable("y"), type: .type(.real))
        let compound = AST.compound(children: [AST.assignment(left: AST.variable("y"), right: AST.number(.integer(5))), AST.call(procedureName: "Alpha", params: [AST.number(.integer(5))]), AST.noOp])
        let node = AST.program(name: "Main", block: AST.block(declarations: [xDec, yDec, alpha], compound: compound))
        XCTAssert(result == node)
    }
}
