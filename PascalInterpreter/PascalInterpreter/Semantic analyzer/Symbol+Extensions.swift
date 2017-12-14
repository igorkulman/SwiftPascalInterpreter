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
        return "<BuiltinTypeSymbol(name='\(self.name)')>"
    }
}
extension VariableSymbol: CustomStringConvertible {
    public var description: String {
        return "<VarSymbol(name='\(name)', type='\(type.name)')>"
    }
}

extension ProcedureSymbol: CustomStringConvertible {
    public var description: String {
        return "<ProcedureSymbol(name=\(name), parameters=[\(params.reduce("", { $0.description + "\($1)," }))]>"
    }
}

extension Symbol {
    var sortOrder: Int {
        switch self {
        case is BuiltInTypeSymbol:
            return 0
        case is VariableSymbol:
            return 1
        case is ProcedureSymbol:
            return 2
        default:
            fatalError("Add sort order for \(self)")
        }
    }
}
