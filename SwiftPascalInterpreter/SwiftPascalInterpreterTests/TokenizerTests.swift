//
//  TokenizerTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftPascalInterpreter

class TokenizerTests: XCTestCase {

    func testIntegerPlusInteger() {
        let interpeter = Interpreter("3+4")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()

        XCTAssert(left == .integer(3))
        XCTAssert(operation == .plus)
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
}
