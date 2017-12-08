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
                a := number;
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
        let compound = AST.compound(children: [AST.assignment(left: number, right: two), AST.assignment(left: a, right: number), empty])
        let node = AST.compound(children: [compound, xAssignment, empty])
        XCTAssert(result == node)
    }
}
