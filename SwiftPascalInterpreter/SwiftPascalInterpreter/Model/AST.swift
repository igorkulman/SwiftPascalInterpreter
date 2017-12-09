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

public enum Type {
    case integer
    case real
}

public enum AST {
    case number(Int)
    indirect case unaryOperation(operation: UnaryOperation, child: AST)
    indirect case binaryOperation(left: AST, operation: BinaryOperation, right: AST)
    indirect case compound(children: [AST])
    indirect case assignment(left: AST, right: AST)
    case variable(String)
    case noOp
    indirect case block(declarations: [AST], compound: AST)
    indirect case variableDeclaration(name: String, type: AST)
    case type(Type)
    indirect case program(name: String, block: AST)
}
