//
//  XCTestCase+FatalError.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import XCTest
@testable import PascalInterpreter

/**
 Taken from https://medium.com/@marcosantadev/how-to-test-fatalerror-in-swift-e1be9ff11a29
 */
extension XCTestCase {
    func expectFatalError(expectedMessage: String, testcase: @escaping () -> Void) {

        let expectation = self.expectation(description: "expectingFatalError")
        var assertionMessage: String?

        FatalErrorUtil.replaceFatalError { message, _, _ in
            assertionMessage = message
            expectation.fulfill()
            self.unreachable()
        }

        DispatchQueue.global(qos: .userInitiated).async(execute: testcase)

        waitForExpectations(timeout: 2) { _ in
            XCTAssertEqual(assertionMessage, expectedMessage)

            FatalErrorUtil.restoreFatalError()
        }
    }

    private func unreachable() -> Never {
        repeat {
            RunLoop.current.run()
        } while true
    }
}

func XCTAssertEqual(_ left: AST, _ right: AST) {
    switch (left, right) {
    case let (Number.integer(left), Number.integer(right)):
        XCTAssert(left == right)
    case let (left as Program, right as Program):
        XCTAssert(left.name == right.name)
        XCTAssertEqual(left.block, right.block)
    case let (left as Block, right as Block):
        XCTAssert(left.declarations.count == right.declarations.count)
        if left.declarations.count > 0 && left.declarations.count == right.declarations.count {
            for i in 0 ... left.declarations.count - 1 {
                XCTAssertEqual(left.declarations[i], right.declarations[i])
            }
        }
        XCTAssertEqual(left.compound, right.compound)
    case let (left as Compound, right as Compound):
        XCTAssert(left.children.count == right.children.count)
        if left.children.count > 0 && left.children.count == right.children.count {
            for i in 0 ... left.children.count - 1 {
                XCTAssertEqual(left.children[i], right.children[i])
            }
        }
    case let (left as Assignment, right as Assignment):
        XCTAssertEqual(left.left, right.left)
        XCTAssertEqual(left.right, right.right)
    case let (left as Variable, right as Variable):
        XCTAssert(left.name == right.name)
    case let (left as BinaryOperation, right as BinaryOperation):
        XCTAssert(left.operation == right.operation)
        XCTAssertEqual(left.left, right.left)
        XCTAssertEqual(left.right, right.right)
    case (is NoOp, is NoOp):
        break
    case let (left as UnaryOperation, right as UnaryOperation):
        XCTAssert(left.operation == right.operation)
        XCTAssertEqual(left.operand, right.operand)
    case let (left as VariableDeclaration, right as VariableDeclaration):
        XCTAssertEqual(left.type, right.type)
        XCTAssertEqual(left.variable, right.variable)
    case let (left as VariableType, right as VariableType):
        XCTAssert(left.type == right.type)
    case let (left as Function, right as Function):
        XCTAssertEqual(left.returnType, right.returnType)
        XCTAssert(left.name == right.name)
        XCTAssertEqual(left.block, right.block)
        XCTAssert(left.params.count == right.params.count)
        if left.params.count > 0 {
            for i in 0 ... left.params.count - 1 {
                XCTAssertEqual(left.params[i], right.params[i])
            }
        }
    case let (left as Procedure, right as Procedure):
        XCTAssert(left.name == right.name)
        XCTAssertEqual(left.block, right.block)
        XCTAssert(left.params.count == right.params.count)
        if left.params.count > 0 {
            for i in 0 ... left.params.count - 1 {
                XCTAssertEqual(left.params[i], right.params[i])
            }
        }
    case let (left as FunctionCall, right as FunctionCall):
        XCTAssert(left.name == right.name)
        XCTAssert(left.actualParameters.count == right.actualParameters.count)
        if left.actualParameters.count > 0 && left.actualParameters.count == right.actualParameters.count {
            for i in 0 ... left.actualParameters.count - 1 {
                XCTAssertEqual(left.actualParameters[i], right.actualParameters[i])
            }
        }
    case let (left as Param, right as Param):
        XCTAssert(left.name == right.name)
        XCTAssertEqual(left.type, right.type)
    case let (left as Condition, right as Condition):
        XCTAssertEqual(left.type, right.type)
        XCTAssertEqual(left.leftSide, right.leftSide)
        XCTAssertEqual(left.rightSide, right.rightSide)
    case let (left as IfElse, right as IfElse):
        XCTAssertEqual(left.trueExpression, right.trueExpression)
        switch (left.falseExpression == nil, right.falseExpression == nil) {
        case (true, false):
            XCTFail("\(String(describing: left.falseExpression)) and \(String(describing: right.falseExpression)) are not equal")
        case (false, true):
            XCTFail("\(String(describing: left.falseExpression)) and \(String(describing: right.falseExpression)) are not equal")
        default:
            break
        }
        XCTAssertEqual(left.condition, right.condition)
        if let leftFalse = left.falseExpression, let rightFalse = right.falseExpression {
            XCTAssertEqual(leftFalse, rightFalse)
        }
    default:
        XCTFail("\(left) and \(right) are not equal")
    }
}
