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
    func testBasicCompoundStatement() {
        let a = AST.variable("a")
        let two = AST.number(2)
        let assignment = AST.assignment(left: a, right: two)
        let empty = AST.noOp
        let node = AST.compound(children: [assignment, empty])
        let parser = Parser("BEGIN a := 2; END.")
        let result = parser.parse()
        XCTAssert(result == node)
    }

    func testMoreComplexExpression() {
        let program =
            """
            BEGIN
                BEGIN
                    number := 2;
                    a := number + 2;
                END;
                x := 11;
            END.
            """

        let parser = Parser(program)
        let result = parser.parse()
        let empty = AST.noOp
        let eleven = AST.number(11)
        let x = AST.variable("x")
        let xAssignment = AST.assignment(left: x, right: eleven)
        let two = AST.number(2)
        let number = AST.variable("number")
        let a = AST.variable("a")
        let aAssignment = AST.assignment(left: a, right: AST.binaryOperation(left: number, operation: .plus, right: two))
        let compound = AST.compound(children: [AST.assignment(left: number, right: two), aAssignment, empty])
        let node = AST.compound(children: [compound, xAssignment, empty])
        XCTAssert(result == node)
    }

    func testEvenMoreComplexExpression() {
        let program =
            """
            BEGIN
                BEGIN
                    number := 2;
                    a := number;
                    a := 10 * a + 10 * number / 4;
                END;
                x := 11;
            END.
            """

        let parser = Parser(program)
        let result = parser.parse()
        let empty = AST.noOp
        let eleven = AST.number(11)
        let x = AST.variable("x")
        let xAssignment = AST.assignment(left: x, right: eleven)
        let two = AST.number(2)
        let number = AST.variable("number")
        let a = AST.variable("a")
        let division = AST.binaryOperation(left: AST.binaryOperation(left: AST.number(10), operation: .mult, right: number), operation: .floatDiv, right: AST.number(4))
        let plus = AST.binaryOperation(left: AST.binaryOperation(left: AST.number(10), operation: .mult, right: a), operation: .plus, right: division)
        let aAssignment = AST.assignment(left: a, right: plus)
        let compound = AST.compound(children: [AST.assignment(left: number, right: two), AST.assignment(left: a, right: number), aAssignment, empty])
        let node = AST.compound(children: [compound, xAssignment, empty])
        XCTAssert(result == node)
    }
}
