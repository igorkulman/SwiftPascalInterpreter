//
//  Symbol+Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension BuiltInType: CustomStringConvertible {
    public var description: String {
        return "<BuiltinTypeSymbol(name='\(self.name)')>"
    }

    public var name: String {
        switch self {
        case .integer:
            return "INTEGER"
        case .real:
            return "REAL"
        }
    }
}

extension Symbol: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .builtIn(type):
            return type.description
        case let .variable(name: name, type: type):
            return "<VarSymbol(name='\(name)', type='\(type.name)')>"
        case let .procedure(name: name, params: params):
            return "<ProcedureSymbol(name=\(name), parameters=[\(params.reduce("", { $0.description + "," + $1.description }))]>"
        }
    }
}

extension Symbol: Equatable {
    public static func == (lhs: Symbol, rhs: Symbol) -> Bool {
        switch (lhs, rhs) {
        case let (.builtIn(left), .builtIn(right)):
            return left == right
        case let (.variable(name: leftName, type: leftType), .variable(name: rightName, type: rightType)):
            return leftName == rightName && leftType == rightType
        default:
            return false
        }
    }

}

extension Symbol {
    public var name: String {
        switch self {
        case let .builtIn(type):
            return type.name
        case .procedure(name: let name, params: _):
            return name
        case .variable(name: let name, type: _):
            return name
        }
    }
}
