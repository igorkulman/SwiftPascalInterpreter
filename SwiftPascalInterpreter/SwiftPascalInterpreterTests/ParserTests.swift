//
//  ParserTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 07/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import SwiftPascalInterpreter
import XCTest

class ParserTests: XCTestCase {
    func testNumber() {
        let node = AST.number(1)
        let parser = Parser("1")
        let result = parser.expr()
        XCTAssert(result == node)
    }

    func testBinaryOperation() {
        let three = AST.number(3)
        let two = AST.number(2)
        let multiplication = AST.binaryOperation(left: three, operation: .mult, right: two)
        let node = AST.binaryOperation(left: multiplication, operation: .div, right: two)
        let parser = Parser("3 * 2 / 2")
        let result = parser.expr()
        XCTAssert(result == node)
    }

    func testBinaryOperationOnSamePriority() {
        let one = AST.number(1)
        let sum = AST.binaryOperation(left: one, operation: .plus, right: one)
        let node = AST.binaryOperation(left: sum, operation: .plus, right: one)
        let parser = Parser("1 + 1 + 1")
        let result = parser.expr()
        XCTAssert(result == node)
    }

    func testBinaryOperationOnTwoNumberAndParentheses() {
        let one = AST.number(1)
        let two = AST.number(2)
        let node = AST.binaryOperation(left: one, operation: .plus, right: two)
        let parser = Parser("1+(2)")
        let result = parser.expr()
        XCTAssert(result == node)
    }

    func testMultipleNodes() {
        let three = AST.number(3)
        let seven = AST.number(7)
        let two = AST.number(2)
        let multiplication = AST.binaryOperation(left: two, operation: .mult, right: seven)
        let node = AST.binaryOperation(left: multiplication, operation: .plus, right: three)
        let parser = Parser("2*7+3")
        let result = parser.expr()
        XCTAssert(result == node)
    }

    func testUnaryOperatorNodesNodes() {
        let five = AST.number(5)
        let two = AST.number(2)
        let un1 = AST.unaryOperation(operation: .minus, child: two)
        let un2 = AST.unaryOperation(operation: .minus, child: un1)
        let node = AST.binaryOperation(left: five, operation: .minus, right: un2)
        let parser = Parser("5 - - - 2")
        let result = parser.expr()
        XCTAssert(result == node)
    }
}
