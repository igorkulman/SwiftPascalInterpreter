//
//  Symbol+Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension BuiltInTypeSymbol: CustomStringConvertible {
    public var description: String {
        return "<BuiltinTypeSymbol(name='\(name)')>"
    }
}

extension VariableSymbol: CustomStringConvertible {
    public var description: String {
        switch self {
        case let arraySymbol as ArraySymbol:
            return "<ArrayVarSymbol(name='\(arraySymbol.name)', type='\(arraySymbol.type.name)', start='\(arraySymbol.startIndex)', end='\(arraySymbol.endIndex)')>"
        default:
            return "<VarSymbol(name='\(name)', type='\(type.name)')>"
        }
    }
}

extension ProcedureSymbol: CustomStringConvertible {
    public var description: String {
        switch self {
        case let function as FunctionSymbol:
            return "<FunctionSymbol(name=\(name), parameters=[\(params.reduce("", { $0.description + "\($1)," }))], returnType=\(function.returnType)>"
        default:
            return "<ProcedureSymbol(name=\(name), parameters=[\(params.reduce("", { $0.description + "\($1)," }))]>"
        }
    }
}

extension BuiltInProcedureSymbol: CustomStringConvertible {
    public var description: String {
        return "<BuiltInProcedureSymbol(name=\(name), parameters=[\(params.reduce("", { $0.description + "\($1)," }))]>"
    }
}

extension Symbol {
    var sortOrder: Int {
        switch self {
        case is BuiltInTypeSymbol:
            return 0
        case is VariableSymbol:
            return 2
        case is FunctionSymbol:
            return 3
        case is ProcedureSymbol:
            return 4
        case is BuiltInProcedureSymbol:
            return 1
        default:
            fatalError("Add sort order for \(self)")
        }
    }
}
