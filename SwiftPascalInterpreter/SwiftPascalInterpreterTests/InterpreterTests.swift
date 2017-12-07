//
//  AnalyzerTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

import Foundation
import XCTest
@testable import SwiftPascalInterpreter

class InterpreterTests: XCTestCase {
    func testSingleInteger() {
        let interpeter = Interpreter("3")
        let result = interpeter.expr()
        XCTAssert(result == 3)
    }

    func testMultipleIntegers() {
        let interpeter = Interpreter("1+2*3")
        let result = interpeter.expr()
        XCTAssert(result == 7)
    }

    func testParentheses() {
        XCTAssert(Interpreter("2 * (7 + 3)").expr() == 20)
        XCTAssert(Interpreter("7 + 3 * (10 / (12 / (3 + 1) - 1))").expr() == 22)
        XCTAssert(Interpreter("7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)").expr() == 10)
        XCTAssert(Interpreter("7 + (((3 + 2)))").expr() == 12)
    }
}
