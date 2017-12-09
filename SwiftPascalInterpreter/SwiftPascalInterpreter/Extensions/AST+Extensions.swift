//
//  AST+Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 09/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension AST: Equatable {
    public static func == (lhs: AST, rhs: AST) -> Bool {
        switch (lhs, rhs) {
        case let (.number(left), .number(right)):
            return left == right
        case let (.unaryOperation(operation: leftOperation, child: leftChild),
                  .unaryOperation(operation: rightOperation, child: rightChild)):
            return leftOperation == rightOperation && leftChild == rightChild
        case let (.binaryOperation(left: leftLeft, operation: leftOperation, right: leftRight),
                  .binaryOperation(left: rightLeft, operation: rightOperation, right: rightRight)):
            return leftLeft == rightLeft && leftOperation == rightOperation && leftRight == rightRight
        case (.noOp, .noOp):
            return true
        case let (.assignment(left: leftLeft, right: leftRight), .assignment(left: rightLeft, right: rightRight)):
            return leftLeft == rightLeft && leftRight == rightRight
        case let (.compound(children: left), .compound(children: right)):
            if left.count != right.count {
                return false
            }
            for i in 0 ... left.count - 1 where left[i] != right[i] {
                return false
            }
            return true
        case let (.variable(left), .variable(right)):
            return left == right
        case let (.type(left), .type(right)):
            return left == right
        case let (.block(declarations: leftDeclarations, compound: leftCompound), .block(declarations: rightDeclarations, compound: rightCompound)):
            return leftDeclarations == rightDeclarations && leftCompound == rightCompound
        case let (.variableDeclaration(name: leftName, type: leftType), .variableDeclaration(name: rightName, type: rightType)):
            return leftName == rightName && leftType == rightType
        default:
            return false
        }
    }
}

extension UnaryOperation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minus:
            return "-"
        case .plus:
            return "+"
        }
    }
}

extension Type: CustomStringConvertible {
    public var description: String {
        switch self {
        case .integer:
            return "INTEGER"
        case .real:
            return "REAL"
        }
    }
}

extension BinaryOperation: CustomStringConvertible {
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

extension AST: CustomStringConvertible {
    public var description: String {
        return treeLines().joined(separator: "\n")
    }
}

extension AST {
    var children: [AST] {
        switch self {
        case .number:
            return []
        case let .unaryOperation(operation: _, child: child):
            return [child]
        case let .binaryOperation(left: left, operation: _, right: right):
            return [left, right]
        case .noOp:
            return []
        case .variable:
            return []
        case let .compound(children: children):
            return children
        case let .assignment(left: left, right: right):
            return [left, right]
        case let .block(declarations, compound):
            var nodes = declarations
            nodes.append(compound)
            return nodes
        case .variableDeclaration:
            return []
        case .type:
            return []
        }
    }

    var value: String {
        switch self {
        case let .number(value):
            return "\(value)"
        case let .unaryOperation(operation: operation, child: _):
            return "u\(operation.description)"
        case let .binaryOperation(left: _, operation: operation, right: _):
            return "\(operation.description)"
        case .noOp:
            return "noOp"
        case let .variable(value):
            return value
        case .compound(children: _):
            return "compound"
        case .assignment(left: _, right: _):
            return ":="
        case .block:
            return "block"
        case let .variableDeclaration(name, type):
            return "\(name): \(type.description)"
        case let .type(type):
            return type.description
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
