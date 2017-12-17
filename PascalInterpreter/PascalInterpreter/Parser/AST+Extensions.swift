//
//  AST+Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 09/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension UnaryOperationType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minus:
            return "-"
        case .plus:
            return "+"
        }
    }
}

extension Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .integer(value):
            return "INTEGER(\(value))"
        case let .real(value):
            return "REAL(\(value))"
        }
    }
}

extension Number: Equatable {
    public static func == (lhs: Number, rhs: Number) -> Bool {
        switch (lhs, rhs) {
        case let (.integer(left), .integer(right)):
            return left == right
        case let (.real(left), .real(right)):
            return left == right
        case let (.real(left), .integer(right)):
            return left == Double(right)
        case let (.integer(left), .real(right)):
            return Double(left) == right
        }
    }
}

extension BinaryOperationType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minus:
            return "-"
        case .plus:
            return "+"
        case .mult:
            return "*"
        case .floatDiv:
            return "//"
        case .integerDiv:
            return "/"
        }
    }
}

extension ConditionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .equals:
            return "="
        case .greaterThan:
            return ">"
        case .lessThan:
            return "<"
        }
    }
}

extension AST {
    var value: String {
        switch self {
        case let number as Number:
            return "\(number)"
        case let unaryOperation as UnaryOperation:
            return "u\(unaryOperation.operation)"
        case let binaryOperation as BinaryOperation:
            return "\(binaryOperation.operation)"
        case is NoOp:
            return "noOp"
        case let variable as Variable:
            return variable.name
        case is Compound:
            return "compound"
        case is Assignment:
            return ":="
        case is Block:
            return "block"
        case is VariableDeclaration:
            return "var"
        case let type as VariableType:
            return "\(type.type)"
        case let program as Program:
            return program.name
        case let function as Function:
            return "\(function.name):\(function.returnType.type)"
        case let procedure as Procedure:
            return procedure.name
        case let param as Param:
            return "param(\(param.name))"
        case let call as FunctionCall:
            return "\(call.name)()"
        case is IfElse:
            return "IF"
        case let condition as Condition:
            return condition.type.description
        case let string as String:
            return string
        default:
            fatalError("Missed AST case \(self)")
        }
    }

    var children: [AST] {
        switch self {
        case is Number:
            return []
        case let unaryOperation as UnaryOperation:
            return [unaryOperation.operand]
        case let binaryOperation as BinaryOperation:
            return [binaryOperation.left, binaryOperation.right]
        case is NoOp:
            return []
        case is Variable:
            return []
        case let compound as Compound:
            return compound.children
        case let assignment as Assignment:
            return [assignment.left, assignment.right]
        case let block as Block:
            var nodes: [AST] = []
            for declaration in block.declarations {
                nodes.append(declaration)
            }
            nodes.append(block.compound)
            return nodes
        case let variableDeclaration as VariableDeclaration:
            return [variableDeclaration.variable, variableDeclaration.type]
        case is VariableType:
            return []
        case let program as Program:
            return [program.block]
        case let function as Function:
            var nodes: [AST] = []
            for param in function.params {
                nodes.append(param)
            }
            nodes.append(function.block)
            return nodes
        case let procedure as Procedure:
            var nodes: [AST] = []
            for param in procedure.params {
                nodes.append(param)
            }
            nodes.append(procedure.block)
            return nodes
        case let param as Param:
            return [param.type]
        case let call as FunctionCall:
            return call.actualParameters
        case let ifelse as IfElse:
            if let falseExpression = ifelse.falseExpression {
                return [ifelse.condition, ifelse.trueExpression, falseExpression]
            }
            return [ifelse.condition, ifelse.trueExpression]
        case let condition as Condition:
            return [condition.leftSide, condition.rightSide]
        case is String:
            return []
        default:
            fatalError("Missed AST case \(self)")
        }
    }

    func treeLines(_ nodeIndent: String = "", _ childIndent: String = "") -> [String] {
        return [nodeIndent + value]
            + children.enumerated().map { ($0 < children.count - 1, $1) }
            .flatMap { $0 ? $1.treeLines("┣╸", "┃ ") : $1.treeLines("┗╸", "  ") }
            .map { childIndent + $0 }
    }

    public func printTree() { print(treeLines().joined(separator: "\n")) }
}
