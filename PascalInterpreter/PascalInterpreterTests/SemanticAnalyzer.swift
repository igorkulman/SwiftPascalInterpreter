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
        analyzer.analyze(node: node)
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
            analyzer.analyze(node: node)
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
            analyzer.analyze(node: node)
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
            analyzer.analyze(node: node)
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
        analyzer.analyze(node: node)
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
            analyzer.analyze(node: node)
        }
    }
}
