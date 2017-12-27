//
//  AST.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 07/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public enum BinaryOperationType {
    case plus
    case minus
    case mult
    case floatDiv
    case integerDiv
}

public enum UnaryOperationType {
    case plus
    case minus
}

public enum ConditionType {
    case equals
    case lessThan
    case greaterThan
}

public enum Number: AST {
    case integer(Int)
    case real(Double)
}

extension String: AST {
}

extension Bool: AST {
}

public protocol AST {
}

public protocol Declaration: AST {
}

class UnaryOperation: AST {
    let operation: UnaryOperationType
    let operand: AST

    init(operation: UnaryOperationType, operand: AST) {
        self.operation = operation
        self.operand = operand
    }
}

class BinaryOperation: AST {
    let left: AST
    let operation: BinaryOperationType
    let right: AST

    init(left: AST, operation: BinaryOperationType, right: AST) {
        self.left = left
        self.operation = operation
        self.right = right
    }
}

class Compound: AST {
    let children: [AST]

    init(children: [AST]) {
        self.children = children
    }
}

class Assignment: AST {
    let left: Variable
    let right: AST
    let index: AST?

    init(left: Variable, right: AST, index: AST? = nil) {
        self.left = left
        self.right = right
        self.index = index
    }
}

class Variable: AST {
    let name: String

    init(name: String) {
        self.name = name
    }
}

class NoOp: AST {
}

class Block: AST {
    let declarations: [Declaration]
    let compound: Compound

    init(declarations: [Declaration], compound: Compound) {
        self.declarations = declarations
        self.compound = compound
    }
}

class VariableType: AST {
    let type: Type

    init(type: Type) {
        self.type = type
    }
}

class VariableDeclaration: Declaration {
    let variable: Variable
    let type: VariableType

    init(variable: Variable, type: VariableType) {
        self.variable = variable
        self.type = type
    }
}

class ArrayDeclaration: VariableDeclaration {
    let startIndex: Int
    let endIndex: Int

    init(variable: Variable, type: VariableType, startIndex: Int, endIndex: Int) {
        self.startIndex = startIndex
        self.endIndex = endIndex

        super.init(variable: variable, type: type)
    }
}

class Program: AST {
    let name: String
    let block: Block

    init(name: String, block: Block) {
        self.name = name
        self.block = block
    }
}

class Procedure: Declaration {
    let name: String
    let params: [Param]
    let block: Block

    init(name: String, params: [Param], block: Block) {
        self.name = name
        self.block = block
        self.params = params
    }
}

class Function: Procedure {
    let returnType: VariableType

    init(name: String, params: [Param], block: Block, returnType: VariableType) {
        self.returnType = returnType
        super.init(name: name, params: params, block: block)
    }
}

class Param: AST {
    let name: String
    let type: VariableType

    init(name: String, type: VariableType) {
        self.name = name
        self.type = type
    }
}

class FunctionCall: AST {
    let name: String
    let actualParameters: [AST]

    init(name: String, actualParameters: [AST]) {
        self.name = name
        self.actualParameters = actualParameters
    }
}

class Condition: AST {
    let type: ConditionType
    let leftSide: AST
    let rightSide: AST

    init(type: ConditionType, leftSide: AST, rightSide: AST) {
        self.type = type
        self.leftSide = leftSide
        self.rightSide = rightSide
    }
}

class IfElse: AST {
    let condition: Condition
    let trueExpression: AST
    let falseExpression: AST?

    init(condition: Condition, trueExpression: AST, falseExpression: AST?) {
        self.condition = condition
        self.trueExpression = trueExpression
        self.falseExpression = falseExpression
    }
}

protocol Loop: AST {
    var statement: AST { get }
    var condition: Condition { get }
}

class RepeatUntil: Loop {
    let statement: AST
    let condition: Condition

    init(statement: AST, condition: Condition) {
        self.statement = statement
        self.condition = condition
    }
}

class While: Loop {
    let statement: AST
    let condition: Condition

    init(statement: AST, condition: Condition) {
        self.statement = statement
        self.condition = condition
    }
}

class For: AST {
    let statement: AST
    let variable: Variable
    let startValue: AST
    let endValue: AST

    init(statement: AST, variable: Variable, startValue: AST, endValue: AST) {
        self.statement = statement
        self.variable = variable
        self.startValue = startValue
        self.endValue = endValue
    }
}
