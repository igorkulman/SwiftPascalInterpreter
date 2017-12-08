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
    func testSingleInteger() {
        let interpeter = Interpreter("3")
        let result = interpeter.eval()
        XCTAssert(result == 3)
    }

    func testMultipleIntegers() {
        let interpeter = Interpreter("1+2*3")
        let result = interpeter.eval()
        XCTAssert(result == 7)
    }

    func testParentheses() {
        XCTAssert(Interpreter("2 * (7 + 3)").eval() == 20)
        XCTAssert(Interpreter("7 + 3 * (10 / (12 / (3 + 1) - 1))").eval() == 22)
        XCTAssert(Interpreter("7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)").eval() == 10)
        XCTAssert(Interpreter("7 + (((3 + 2)))").eval() == 12)
    }

    func testUnaryOperations() {
        let interpeter = Interpreter("5 - - -2")
        let result = interpeter.eval()
        XCTAssert(result == 3)
    }
}
