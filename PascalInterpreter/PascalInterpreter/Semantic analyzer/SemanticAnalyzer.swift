//
//  SymbolTableBuilder.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class SemanticAnalyzer {
    private var currentScope: ScopedSymbolTable?

    public init() {

    }

    public func build(node: AST) -> ScopedSymbolTable {
        visit(node: node)
        return ScopedSymbolTable(name: "global", level: 1, enclosingScope: nil)
    }

    private func visit(node: AST) {
        switch node {
        case let .block(declarations: declarations, compound: compoundStatement):
            for declaration in declarations {
                visit(node: declaration)
            }
            visit(node: compoundStatement)
        case let .program(name: _, block: block):
            let globalScope = ScopedSymbolTable(name: "global", level: 1, enclosingScope: nil)
            currentScope = globalScope
            visit(node: block)
            print(globalScope)
            currentScope = nil
        case let .binaryOperation(left: left, operation: _, right: right):
            visit(node: left)
            visit(node: right)
        case .number:
            break
        case let .unaryOperation(operation: _, child: child):
            visit(node: child)
        case let .compound(children: children):
            for child in children {
                visit(node: child)
            }
        case .noOp:
            break
        case let .variable(name):
            guard let scope = currentScope else {
                fatalError("Cannot access a variable outside a scope")
            }
            guard scope.lookup(name) != nil else {
                fatalError("Symbol(indetifier) not found '\(name)'")
            }
        case let .variableDeclaration(name: variable, type: variableType):
            guard let scope = currentScope else {
                fatalError("Cannot declare a variable outside a scope")
            }

            guard case let .variable(name) = variable, case let .type(type) = variableType else {
                fatalError("Invalid variable \(variable) or invalid type \(variableType)")
            }

            guard scope.lookup(name, currentScopeOnly: true) == nil else {
                fatalError("Duplicate identifier '\(name)' found")
            }

            guard let symbolType = scope.lookup(type.description) else {
                fatalError("Type not found '\(type.description)'")
            }

            scope.insert(.variable(name: name, type: symbolType))
        case let .assignment(left: left, right: right):
            visit(node: right)
            visit(node: left)
        case .type:
            break
        case let .procedure(name: name, params: params, block: block):
            let scope = ScopedSymbolTable(name: name, level: (currentScope?.level ?? 0) + 1, enclosingScope: currentScope)
            currentScope = scope

            var parameters: [Symbol] = []
            for param in params {
                guard case let .param(name: name, type: .type(type)) = param else {
                    fatalError("Only built int type parameters supported in procedure, got \(param)")
                }
                guard let symbol = scope.lookup(type.description) else {
                    fatalError("Type not found '\(type.description)'")
                }
                let variable = Symbol.variable(name: name, type: symbol)
                parameters.append(variable)
                scope.insert(variable)
            }
            let symbol = Symbol.procedure(name: name, params: parameters)
            scope.insert(symbol)

            visit(node: block)
            print(scope)
            currentScope = currentScope?.enclosingScope
        case .param:
            break
        }
    }
}
