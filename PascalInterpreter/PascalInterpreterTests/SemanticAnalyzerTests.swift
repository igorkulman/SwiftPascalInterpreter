//
//  SymbolTableTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

import Foundation
@testable import PascalInterpreter
import XCTest

class SemanticAnalyzerTests: XCTestCase {
    func testSemanticAnalyzer() {
        let program =
            """
            PROGRAM Part10AST;
            VAR
                a, b, number : INTEGER;
                y            : REAL;
            BEGIN
                BEGIN
                    number := 2;
                    a := number;
                    a := 10 * a + 10 * number / 4;
                END;
                y := 11;
            END.
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        let state = analyzer.analyze(node: node)
        XCTAssert(state.keys.count == 1)
        XCTAssert(state["global"] != nil)
        XCTAssert(state["global"]!.level == 1)
        XCTAssert(state["global"]!.lookup("y") != nil)
        XCTAssert(state["global"]!.lookup("a") != nil)
        XCTAssert(state["global"]!.lookup("b") != nil)
        XCTAssert(state["global"]!.lookup("number") != nil)
        XCTAssert(state["global"]!.lookup("c") == nil)
    }

    func testSemanticAnalyzerAssignUndeclaredVariable() {
        let program =
            """
            PROGRAM Part10AST;
            VAR
                a, b, number : INTEGER;
                y            : REAL;
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
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        expectFatalError(expectedMessage: "Symbol(indetifier) not found 'x'") {
            _ = analyzer.analyze(node: node)
        }
    }

    func testSemanticAnalyzerUndeclaredVariable() {
        let program =
            """
                program SymTab5;
                var x : integer;

                begin
                    x := y;
                end.
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        expectFatalError(expectedMessage: "Symbol(indetifier) not found 'y'") {
            _ = analyzer.analyze(node: node)
        }
    }

    func testSemanticAnalyzerMultipleDeclarations() {
        let program =
            """
                program SymTab6;
                var x, y : integer;
                    y : real;

                begin
                x := x + y;
                end.
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        expectFatalError(expectedMessage: "Duplicate identifier 'y' found") {
            _ = analyzer.analyze(node: node)
        }
    }

    func testSemanticAnalyzerProcedure() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha(a : integer);
            var y : integer;
            begin
                x := a + x + y;
            end;

            begin { Main }

            end.  { Main }
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        let state = analyzer.analyze(node: node)
        XCTAssert(state.keys.count == 2)
        XCTAssert(state["global"] != nil)
        XCTAssert(state["global"]!.level == 1)
        XCTAssert(state["global"]!.lookup("x") != nil)
        XCTAssert(state["global"]!.lookup("y") != nil)
        XCTAssert(state["global"]!.lookup("a") == nil)
        XCTAssert(state.keys.count == 2)
        XCTAssert(state["Alpha"] != nil)
        XCTAssert(state["Alpha"]!.level == 2)
        XCTAssert(state["Alpha"]!.lookup("x") != nil)
        XCTAssert(state["Alpha"]!.lookup("y") != nil)
        XCTAssert(state["Alpha"]!.lookup("a") != nil)
    }

    func testSemanticAnalyzerUndeclaredProcedure() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha(a : integer);
            var y : integer;
            begin
                x := a + x + y;
            end;

            begin { Main }
            Beta();
            end.  { Main }
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        expectFatalError(expectedMessage: "Symbol(procedure) not found 'Beta'") {
            _ = analyzer.analyze(node: node)
        }
    }

    func testSemanticAnalyzerProcedureCall() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha();
            var y : integer;
            begin
                x := x + y;
            end;

            begin { Main }
            Alpha();
            end.  { Main }
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        let state = analyzer.analyze(node: node)
        XCTAssert(state.keys.count == 2)
        XCTAssert(state["global"] != nil)
        XCTAssert(state["global"]!.level == 1)
        XCTAssert(state["global"]!.lookup("x") != nil)
        XCTAssert(state["global"]!.lookup("y") != nil)
        XCTAssert(state["global"]!.lookup("a") == nil)
        XCTAssert(state.keys.count == 2)
        XCTAssert(state["Alpha"] != nil)
        XCTAssert(state["Alpha"]!.level == 2)
        XCTAssert(state["Alpha"]!.lookup("x") != nil)
        XCTAssert(state["Alpha"]!.lookup("y") != nil)
        XCTAssert(state["Alpha"]!.lookup("a") == nil)
    }

    func testSemanticAnalyzerProcedureUndeclaredVariable() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha(a : integer);
            var y : integer;
            begin
                x := a + x + b;
            end;

            begin { Main }

            end.  { Main }
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        expectFatalError(expectedMessage: "Symbol(indetifier) not found 'b'") {
            _ = analyzer.analyze(node: node)
        }
    }

    func testSemanticAnalyzerProcedureCallWithoutParameter() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha(a : integer);
            var y : integer;
            begin
                x := a + x;
            end;

            begin { Main }
            Alpha()
            end.  { Main }
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        expectFatalError(expectedMessage: "Procedure called with wrong number of parameters 'Alpha'") {
            _ = analyzer.analyze(node: node)
        }
    }

    func testSemanticAnalyzerProcedureCallWithParameter() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha(a : integer);
            var y : integer;
            begin
                x := a + x;
            end;

            begin { Main }
            Alpha(5)
            end.  { Main }
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        let state = analyzer.analyze(node: node)
        XCTAssert(state.keys.count == 2)
        XCTAssert(state["global"] != nil)
        XCTAssert(state["global"]!.level == 1)
        XCTAssert(state["global"]!.lookup("x") != nil)
        XCTAssert(state["global"]!.lookup("y") != nil)
        XCTAssert(state["global"]!.lookup("a") == nil)
        XCTAssert(state.keys.count == 2)
        XCTAssert(state["Alpha"] != nil)
        XCTAssert(state["Alpha"]!.level == 2)
        XCTAssert(state["Alpha"]!.lookup("x") != nil)
        XCTAssert(state["Alpha"]!.lookup("y") != nil)
        XCTAssert(state["Alpha"]!.lookup("a") != nil)
    }

    func testSemanticAnalyzerProcedureCallWithParameterWrongType() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha(a : integer);
            var y : integer;
            begin
                x := a + x;
            end;

            begin { Main }
            Alpha(5.2)
            end.  { Main }
            """

        let parser = Parser(program)
        let node = parser.parse()

        let analyzer = SemanticAnalyzer()
        expectFatalError(expectedMessage: "Cannot assing Real to Integer parameter in procedure call 'Alpha'") {
            _ = analyzer.analyze(node: node)
        }
    }
}
