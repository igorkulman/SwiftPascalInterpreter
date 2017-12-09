//
//  AnalyzerTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Foundation
@testable import SwiftPascalInterpreter
import XCTest

class InterpreterTests: XCTestCase {
    func testSimpleProgram() {
        let program =
        """
        PROGRAM Part10AST;
        BEGIN
            a := 2
        END.
        """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let state = interpeter.getState()
        XCTAssert(state == ["a": 2])
    }

    func testMoreComplexProgram() {
        let program =
            """
            PROGRAM Part10AST;
            BEGIN
                BEGIN
                    number := 2;
                    a := number;
                    b := 10 * a + 10 * number / 4;
                    c := a - - b
                END;
                x := 11;
            END.
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let state = interpeter.getState()
        XCTAssert(state == ["b": 25, "number": 2, "a": 2, "x": 11, "c": 27])
    }

    func testProgramWithDeclarations() {
        let program =
        """
        PROGRAM Part10AST;
        VAR
            a, b : INTEGER;
            y    : REAL;

        BEGIN {Part10AST}
            a := 2;
            b := 10 * a + 10 * a DIV 4;
            y := 20 / 7 + 3.14;
        END.  {Part10AST}
        """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let state = interpeter.getState()
        XCTAssert(state == ["b": 25, "number": 2, "a": 2, "x": 11, "c": 27])
    }
}
