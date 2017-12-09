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
        VAR
            a: INTEGER;
        BEGIN
            a := 2
        END.
        """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (integerState, realState) = interpeter.getState()
        XCTAssert(integerState == ["a": 2])
        XCTAssert(realState == [:])
    }

    func testMoreComplexProgram() {
        let program =
            """
            PROGRAM Part10AST;
            VAR
                 a, number, b, c: INTEGER;
            BEGIN
                BEGIN
                    number := 2;
                    a := number;
                    b := 10 * a + 10 * number DIV 4;
                    c := a - - b
                END;
                x := 11;
            END.
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (integerState, realState) = interpeter.getState()
        XCTAssert(integerState == ["b": 25, "number": 2, "a": 2, "x": 11, "c": 27])
        XCTAssert(realState == [:])
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
        let (integerState, realState) = interpeter.getState()
        //XCTAssert((integerState, realState) == ["b": 25, "y": 5, "a": 2])
    }
}
