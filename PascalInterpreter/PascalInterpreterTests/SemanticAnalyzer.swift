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
        let table = SymbolTable()
        table.insert(.variable(name: "y", type: .real))
        table.insert(.variable(name: "a", type: .integer))
        table.insert(.variable(name: "b", type: .integer))
        table.insert(.variable(name: "number", type: .integer))

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
        let result = analyzer.build(node: node)
        XCTAssert(result == table)
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
            _ = analyzer.build(node: node)
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
            _ = analyzer.build(node: node)
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
            _ = analyzer.build(node: node)
        }
    }
}
