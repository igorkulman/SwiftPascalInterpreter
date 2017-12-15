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

        let a = Variable(name: "a")
        let two = Number.integer(2)
        let assignment = Assignment(left: a, right: two)
        let block = Block(declarations: [], compound: Compound(children: [assignment]))
        let node = Program(name: "Part10AST", block: block)
        let parser = Parser(program)
        let result = parser.parse()
        XCTAssertEqual(result, node)
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
        let empty = NoOp()
        let eleven = Number.integer(11)
        let x = Variable(name: "x")
        let xAssignment = Assignment(left: x, right: eleven)
        let two = Number.integer(2)
        let number = Variable(name: "number")
        let a = Variable(name: "a")
        let aAssignment = Assignment(left: a, right: BinaryOperation(left: number, operation: .plus, right: two))
        let compound = Compound(children: [Assignment(left: number, right: two), aAssignment, empty])
        let block = Block(declarations: [], compound: Compound(children: [compound, xAssignment, empty]))
        let node = Program(name: "Part10AST", block: block)
        XCTAssertEqual(result, node)
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
        let empty = NoOp()
        let eleven = Number.integer(11)
        let x = Variable(name: "x")
        let xAssignment = Assignment(left: x, right: eleven)
        let two = Number.integer(2)
        let number = Variable(name: "number")
        let a = Variable(name: "a")
        let division = BinaryOperation(left: BinaryOperation(left: Number.integer(10), operation: .mult, right: number), operation: .floatDiv, right: Number.integer(4))
        let plus = BinaryOperation(left: BinaryOperation(left: Number.integer(10), operation: .mult, right: a), operation: .plus, right: division)
        let aAssignment = Assignment(left: a, right: plus)
        let compound = Compound(children: [Assignment(left: number, right: two), Assignment(left: a, right: number), aAssignment, empty])
        let node = Program(name: "Part10AST", block: Block(declarations: [], compound: Compound(children: [compound, xAssignment, empty])))
        XCTAssertEqual(result, node)
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
        let empty = NoOp()
        let eleven = Number.integer(11)
        let x = Variable(name: "x")
        let xAssignment = Assignment(left: x, right: eleven)
        let two = Number.integer(2)
        let number = Variable(name: "number")
        let a = Variable(name: "a")
        let division = BinaryOperation(left: BinaryOperation(left: Number.integer(10), operation: .mult, right: number), operation: .floatDiv, right: Number.integer(4))
        let plus = BinaryOperation(left: BinaryOperation(left: Number.integer(10), operation: .mult, right: a), operation: .plus, right: division)
        let aAssignment = Assignment(left: a, right: plus)
        let compound = Compound(children: [Assignment(left: number, right: two), Assignment(left: a, right: number), aAssignment, empty])
        let aDec = VariableDeclaration(variable: Variable(name: "a"), type: VariableType(type: .integer))
        let bDec = VariableDeclaration(variable: Variable(name: "b"), type: VariableType(type: .integer))
        let yDec = VariableDeclaration(variable: Variable(name: "y"), type: VariableType(type: .real))
        let node = Program(name: "Part10AST", block: Block(declarations: [aDec, bDec, yDec], compound: Compound(children: [compound, xAssignment, empty])))
        XCTAssertEqual(result, node)
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
        let empty = NoOp()
        let two = Number.integer(2)
        let a = Variable(name: "a")
        let compound = Compound(children: [Assignment(left: a, right: two), empty])
        let aDec = VariableDeclaration(variable: Variable(name: "a"), type: VariableType(type: .integer))
        let bDec = VariableDeclaration(variable: Variable(name: "b"), type: VariableType(type: .integer))
        let p1 = Procedure(name: "P1", params: [], block: Block(declarations: [], compound: Compound(children: [empty])))
        let node = Program(name: "Part10AST", block: Block(declarations: [aDec, bDec, p1], compound: compound))
        XCTAssertEqual(result, node)
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
        let empty = NoOp()
        let ten = Number.integer(10)
        let a = Variable(name: "a")
        let compound = Compound(children: [Assignment(left: a, right: ten), empty])
        let aDec = VariableDeclaration(variable: Variable(name: "a"), type: VariableType(type: .integer))
        let p2 = Procedure(name: "P2", params: [], block: Block(declarations: [VariableDeclaration(variable: Variable(name: "a"), type: VariableType(type: .integer)), VariableDeclaration(variable: Variable(name: "z"), type: VariableType(type: .integer))], compound: Compound(children: [Assignment(left: Variable(name: "z"), right: Number.integer(777)), empty])))
        let p1 = Procedure(name: "P1", params: [], block: Block(declarations: [VariableDeclaration(variable: Variable(name: "a"), type: VariableType(type: .real)), VariableDeclaration(variable: Variable(name: "k"), type: VariableType(type: .integer)), p2], compound: Compound(children: [empty])))
        let node = Program(name: "Part12", block: Block(declarations: [aDec, p1], compound: compound))
        XCTAssertEqual(result, node)
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
        let alpha = Procedure(name: "Alpha", params: [], block: Block(declarations: [], compound: Compound(children: [Assignment(left: Variable(name: "x"), right: Number.integer(5)), NoOp()])))
        let xDec = VariableDeclaration(variable: Variable(name: "x"), type: VariableType(type: .real))
        let yDec = VariableDeclaration(variable: Variable(name: "y"), type: VariableType(type: .real))
        let compound = Compound(children: [ProcedureCall(name: "Alpha", actualParameters: []), Assignment(left: Variable(name: "y"), right: Number.integer(5)), ProcedureCall(name: "Alpha", actualParameters: []), NoOp()])
        let node = Program(name: "Main", block: Block(declarations: [xDec, yDec, alpha], compound: compound))
        XCTAssertEqual(result, node)
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
        let alpha = Procedure(name: "Alpha", params: [Param(name: "a", type: VariableType(type: .integer))], block: Block(declarations: [], compound: Compound(children: [Assignment(left: Variable(name: "x"), right: BinaryOperation(left: Number.integer(5), operation: .plus, right: Variable(name: "a"))), NoOp()])))
        let xDec = VariableDeclaration(variable: Variable(name: "x"), type: VariableType(type: .real))
        let yDec = VariableDeclaration(variable: Variable(name: "y"), type: VariableType(type: .real))
        let compound = Compound(children: [Assignment(left: Variable(name: "y"), right: Number.integer(5)), ProcedureCall(name: "Alpha", actualParameters: [Number.integer(5)]), NoOp()])
        let node = Program(name: "Main", block: Block(declarations: [xDec, yDec, alpha], compound: compound))
        XCTAssertEqual(result, node)
    }

    func testProgramWithIfElseCondition() {
        let program =
            """
            program Main;
            var x, y: real;

            begin { Main }
            y := 5;
            if (y = 5) then
                x:=2
            else
                x:= 3
            end.  { Main }
            """
        let parser = Parser(program)
        let result = parser.parse()
        let xDec = VariableDeclaration(variable: Variable(name: "x"), type: VariableType(type: .real))
        let yDec = VariableDeclaration(variable: Variable(name: "y"), type: VariableType(type: .real))
        let compound = Compound(children: [Assignment(left: Variable(name: "y"), right: Number.integer(5)), IfElse(condition: Condition(leftSide: Variable(name: "y"), rightSide: Number.integer(5)), trueExpression: Assignment(left: Variable(name: "x"), right: Number.integer(2)), falseExpression: Assignment(left: Variable(name: "x"), right: Number.integer(3)))])
        let node = Program(name: "Main", block: Block(declarations: [xDec, yDec], compound: compound))
        XCTAssertEqual(result, node)
    }

    func testProgramWithIfCondition() {
        let program =
        """
            program Main;
            var x, y: real;

            begin { Main }
            y := 5;
            if (y = 5) then
                x:=2
            end.  { Main }
            """
        let parser = Parser(program)
        let result = parser.parse()
        let xDec = VariableDeclaration(variable: Variable(name: "x"), type: VariableType(type: .real))
        let yDec = VariableDeclaration(variable: Variable(name: "y"), type: VariableType(type: .real))
        let compound = Compound(children: [Assignment(left: Variable(name: "y"), right: Number.integer(5)), IfElse(condition: Condition(leftSide: Variable(name: "y"), rightSide: Number.integer(5)), trueExpression: Assignment(left: Variable(name: "x"), right: Number.integer(2)), falseExpression: nil)])
        let node = Program(name: "Main", block: Block(declarations: [xDec, yDec], compound: compound))
        XCTAssertEqual(result, node)
    }

    func testProgramWithProcedureWithVariable() {
        let program =
        """
            program Main;
            begin { Main }
            Factorial(x);
            end.  { Main }
            """

        let parser = Parser(program)
        let result = parser.parse()
        let compound = Compound(children: [ProcedureCall(name: "Factorial", actualParameters: [])])
        let node = Program(name: "Main", block: Block(declarations: [], compound: compound))
        XCTAssertEqual(result, node)
    }
}
