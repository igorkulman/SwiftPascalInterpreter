//
//  AnalyzerTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Foundation
@testable import PascalInterpreter
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
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["A": Value.number(.integer(2))])
        XCTAssert(arrays.count == 0)
    }

    func testMoreComplexProgram() {
        let program =
            """
            PROGRAM Part10AST;
            VAR
                 a, number, b, c, x: INTEGER;
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
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["B": Value.number(.integer(25)), "NUMBER": Value.number(.integer(2)), "A": Value.number(.integer(2)), "X": Value.number(.integer(11)), "C": Value.number(.integer(27))])
        XCTAssert(arrays.count == 0)
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
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["B": Value.number(.integer(25)), "A": Value.number(.integer(2)), "Y": Value.number(.real(5.9971428571428573))])
        XCTAssert(arrays.count == 0)
    }

    func testProgramWithProcedureCallAndNoParameters() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha();
            var a: integer;
            begin
            a := 2;
            x := y + a;
            end;

            begin { Main }
            y := 5;
            Alpha();
            end.  { Main }
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["X": Value.number(.real(7)), "Y": Value.number(.real(5))])
        XCTAssert(arrays.count == 0)
    }

    func testProgramWithProcedureCallAndParameters() {
        let program =
            """
            program Main;
            var x, y: real;

            procedure Alpha(a: Integer);
            begin
            x := y + a;
            end;

            begin { Main }
            y := 3;
            Alpha(2);
            end.  { Main }
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["X": Value.number(.real(5)), "Y": Value.number(.real(3))])
        XCTAssert(arrays.count == 0)
    }

    func testProgramWithRecursiveFunction() {
        let program =
            """
            program Main;
            var result: integer;

            function Factorial(number: Integer): Integer;
            begin
            if number > 1 then
                Factorial := number * Factorial(number-1)
            else
                Factorial := 1
            end;

            begin { Main }
            result := Factorial(6);
            end.  { Main }
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["RESULT": Value.number(.integer(720))])
        XCTAssert(arrays.count == 0)
    }

    func testProgramWithRecursiveAndBuiltInFunctions() {
        let program =
            """
            program Main;
            var result: integer;

            function Factorial(number: Integer): Integer;
            begin
            if number > 1 then
                Factorial := number * Factorial(number-1)
            else
                Factorial := 1
            end;

            begin { Main }
            result := Factorial(6);
            writeln(result);
            end.  { Main }
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["RESULT": Value.number(.integer(720))])
        XCTAssert(arrays.count == 0)
    }

    func testProgramWithRecursiveFunctionsAndParameterTheSameName() {
        let program =
            """
            program Main;
            var number, result: integer;

            function Factorial(number: Integer): Integer;
            begin
            if number > 1 then
                Factorial := number * Factorial(number-1)
            else
                Factorial := 1
            end;

            begin { Main }
            number := 6;
            result := Factorial(number);
            end.  { Main }
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["RESULT": Value.number(.integer(720)), "NUMBER": Value.number(.integer(6))])
        XCTAssert(arrays.count == 0)
    }

    func testProgramWithRepeatUntil() {
        let program =
            """
            program Main;
            var x: integer;

            begin
            x:=0;
            repeat
                x:=x+1;
            until x = 6;
            writeln(x);
            end.  { Main }
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["X": Value.number(.integer(6))])
        XCTAssert(arrays.count == 0)
    }

    func testProgramWithForLoop() {
        let program =
            """
            program Main;
            var x: Integer;

            begin
            for i:=1 to 6 do begin
                writeln(i);
                x:= i
            end;
            end.  { Main }
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == ["X": Value.number(.integer(6))])
        XCTAssert(arrays.count == 0)
    }

    func testProgramWithArray() {
        let program =
            """
            program Main;
            var data: array [1..5] of Integer;

            begin
            for i:=1 to length(data) do
            begin
                data[i] := i;
            end;
            writeln(data[2]);
            end.
            """

        let interpeter = Interpreter(program)
        interpeter.interpret()
        let (scalars, arrays) = interpeter.getState()
        XCTAssert(scalars == [:])
        XCTAssert(arrays.count == 1)
        XCTAssert(arrays["DATA"]! == [Value.number(.integer(1)), Value.number(.integer(2)), Value.number(.integer(3)), Value.number(.integer(4)), Value.number(.integer(5))])
    }
}
