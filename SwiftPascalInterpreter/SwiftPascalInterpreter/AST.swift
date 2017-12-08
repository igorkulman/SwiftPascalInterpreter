//
//  AST.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 07/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public enum AST {
    case number(Int)
    indirect case unaryOperation(operation: Operation, child: AST)
    indirect case binaryOperation(left: AST, operation: Operation, right: AST)
}
