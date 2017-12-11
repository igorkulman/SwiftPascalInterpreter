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

class SymbolTableTests: XCTestCase {
    func testSymbolTableBuilder() {
        let table = SymbolTable()
        table.define(.variable(name: "y", type: .real))
        table.define(.variable(name: "a", type: .integer))
        table.define(.variable(name: "b", type: .integer))
        table.define(.variable(name: "number", type: .integer))

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

        let builder = SymbolTableBuilder()
        let result = builder.build(node: node)
        XCTAssert(result == table)
    }

    func testSymbolTableBuilderAssignmentVerificationFail() {
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

        let builder = SymbolTableBuilder()
        expectFatalError(expectedMessage: "Cannot assign to undeclared variable x") {
            _ = builder.build(node: node)
        }
    }

    func testSymbolTableBuilderUsageVerificationFail() {
        let program =
        """
            PROGRAM Part10AST;
            VAR
                a, b, number : INTEGER;
                y            : REAL;
            BEGIN
                BEGIN
                    number := 2;
                    a := c;
                    a := 10 * a + 10 * number / 4;
                END;
                x := 11;
            END.
            """

        let parser = Parser(program)
        let node = parser.parse()

        let builder = SymbolTableBuilder()
        expectFatalError(expectedMessage: "Cannot use undeclared variable c") {
            _ = builder.build(node: node)
        }
    }
}
