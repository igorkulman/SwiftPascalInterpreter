//
//  SymbolTableTests.swift
//  SwiftPascalInterpreterTests
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

import Foundation
@testable import SwiftPascalInterpreter
import XCTest

class SymbolTableTests: XCTestCase {
    func testSymbolTableBuilder() {
        let table = SymbolTable()
        table.define(.variable(name: "y", type: .real))
        table.define(.variable(name: "a", type: .integer))
        table.define(.variable(name: "b", type: .integer))
        table.define(.variable(name: "number", type: .integer))

        let empty = AST.noOp
        let eleven = AST.number(.integer(11))
        let y = AST.variable("y")
        let xAssignment = AST.assignment(left: y, right: eleven)
        let two = AST.number(.integer(2))
        let number = AST.variable("number")
        let a = AST.variable("a")
        let division = AST.binaryOperation(left: AST.binaryOperation(left: AST.number(.integer(10)), operation: .mult, right: number), operation: .floatDiv, right: AST.number(.integer(4)))
        let plus = AST.binaryOperation(left: AST.binaryOperation(left: AST.number(.integer(10)), operation: .mult, right: a), operation: .plus, right: division)
        let aAssignment = AST.assignment(left: a, right: plus)
        let compound = AST.compound(children: [AST.assignment(left: number, right: two), AST.assignment(left: a, right: number), aAssignment, empty])
        let aDec = AST.variableDeclaration(name: AST.variable("a"), type: .type(.integer))
        let bDec = AST.variableDeclaration(name: AST.variable("b"), type: .type(.integer))
        let yDec = AST.variableDeclaration(name: AST.variable("y"), type: .type(.real))
        let numberDec = AST.variableDeclaration(name: AST.variable("number"), type: .type(.integer))
        let node = AST.program(name: "Part10AST", block: AST.block(declarations: [aDec, bDec, yDec, numberDec], compound: AST.compound(children: [compound, xAssignment, empty])))

        let builder = SymbolTableBuilder()
        let result = builder.build(node: node)
        XCTAssert(result == table)
    }
}
