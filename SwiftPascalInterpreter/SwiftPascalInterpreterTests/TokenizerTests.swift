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
    
    func testEmptyInput() {
        let interpeter = Interpreter("")
        let eof = interpeter.getNextToken()
        XCTAssert(eof == .eof)
    }
    
    func testWhitespaceOnlyInput() {
        let interpeter = Interpreter(" ")
        let eof = interpeter.getNextToken()
        XCTAssert(eof == .eof)
    }
    
    func testIntegerPlusInteger() {
        let interpeter = Interpreter("3+4")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()
        
        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
    
    func testIntegerTimesInteger() {
        let interpeter = Interpreter("3*4")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()
        
        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.times))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
    
    func testIntegerDivideInteger() {
        let interpeter = Interpreter("3/4")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()
        
        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.divide))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
    
    func testMinusPlusInteger() {
        let interpeter = Interpreter("3 -4")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()
        
        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.minus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
    
    func testIntegerPlusIntegerWithWhiteSace1() {
        let interpeter = Interpreter("3 +4")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()
        
        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
    
    func testIntegerPlusIntegerWithWhiteSace2() {
        let interpeter = Interpreter("3 + 4")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()
        
        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
    
    func testIntegerPlusIntegerWithWhiteSace3() {
        let interpeter = Interpreter(" 3 + 4")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()
        
        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
    
    func testIntegerPlusIntegerWithWhiteSace4() {
        let interpeter = Interpreter("3+ 4 ")
        let left = interpeter.getNextToken()
        let operation = interpeter.getNextToken()
        let right = interpeter.getNextToken()
        let eof = interpeter.getNextToken()
        
        XCTAssert(left == .integer(3))
        XCTAssert(operation == .operation(.plus))
        XCTAssert(right == .integer(4))
        XCTAssert(eof == .eof)
    }
}
