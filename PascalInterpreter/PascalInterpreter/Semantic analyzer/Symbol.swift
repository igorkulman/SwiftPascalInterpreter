//
//  Symbol.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

protocol Symbol {
    var name: String { get }
}

public enum BuiltInTypeSymbol: Symbol {
    case integer
    case real
    case boolean
    case string

    var name: String {
        switch self {
        case .integer:
            return "INTEGER"
        case .real:
            return "REAL"
        case .boolean:
            return "BOOLEAN"
        case .string:
            return "STRING"
        }
    }
}

class VariableSymbol: Symbol {
    let name: String
    let type: Symbol

    init(name: String, type: Symbol) {
        self.name = name
        self.type = type
    }
}

class ProcedureSymbol: Symbol {
    let name: String
    let params: [Symbol]
    let body: Procedure

    init(name: String, parameters: [Symbol], body: Procedure) {
        self.name = name
        self.params = parameters
        self.body = body
    }
}

class FunctionSymbol: ProcedureSymbol {
    let returnType: Symbol

    init(name: String, parameters: [Symbol], body: Procedure, returnType: Symbol) {
        self.returnType = returnType
        super.init(name: name, parameters: parameters, body: body)
    }
}

class BuiltInProcedureSymbol: Symbol {
    let name: String
    let params: [Symbol]
    let hasVariableParameters: Bool

    init(name: String, parameters: [Symbol], hasVariableParameters: Bool) {
        self.name = name
        self.params = parameters
        self.hasVariableParameters = hasVariableParameters
    }
}
