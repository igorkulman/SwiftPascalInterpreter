//
//  AST.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 07/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public enum BinaryOperation {
    case plus
    case minus
    case mult
    case floatDiv
    case integerDiv
}

public enum UnaryOperation {
    case plus
    case minus
}

public enum Number {
    case integer(Int)
    case real(Double)
}

public indirect enum AST {
    case number(Number)
    case unaryOperation(operation: UnaryOperation, child: AST)
    case binaryOperation(left: AST, operation: BinaryOperation, right: AST)
    case compound(children: [AST])
    case assignment(left: AST, right: AST)
    case variable(String)
    case noOp
    case block(declarations: [AST], compound: AST)
    case variableDeclaration(name: AST, type: AST)
    case type(Type)
    case program(name: String, block: AST)
    case procedure(name: String, params: [AST], block: AST)
    case param(name: String, type: AST)
}
