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
    func testBasicExpression() {
        let a = AST.variable("a")
        let two = AST.number(2)
        let assignment = AST.assignment(left: a, right: two)
        let empty = AST.noOp
        let node = AST.compound(children: [assignment, empty])
        let parser = Parser("BEGIN a := 2; END.")
        let result = parser.parse()
        XCTAssert(result == node)
    }
}
