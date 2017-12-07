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
        XCTAssert(result == 9)
    }
}
