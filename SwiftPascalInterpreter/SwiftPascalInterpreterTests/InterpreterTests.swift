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
    func testSimpleDeclaration() {
        let interpeter = Interpreter("BEGIN a := 2; END.")
        interpeter.interpret()
        let state = interpeter.getState()
        XCTAssert(state == ["a": 2])
    }

    func testComplexDeclaration() {
        let program =
            """
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
}
