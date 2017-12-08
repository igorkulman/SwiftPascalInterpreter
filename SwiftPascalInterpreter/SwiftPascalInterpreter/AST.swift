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
    case div
}

public enum UnaryOperation {
    case plus
    case minus
}

public enum AST {
    case number(Int)
    indirect case unaryOperation(operation: UnaryOperation, child: AST)
    indirect case binaryOperation(left: AST, operation: BinaryOperation, right: AST)
}
