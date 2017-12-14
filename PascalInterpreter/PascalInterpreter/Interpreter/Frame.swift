//
//  Frame.swift
//  PascalInterpreter
//
//  Created by Igor Kulman on 13/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

class Frame {
    var integerMemory: [String: Int] = [:]
    var realMemory: [String: Double] = [:]
    let scope: ScopedSymbolTable
    let previousFrame: Frame?

    init(scope: ScopedSymbolTable, previousFrame: Frame?) {
        self.scope = scope
        self.previousFrame = previousFrame
    }

    func set(variable: String, value: Number) {
        // variable define in current scole (procedure declataion, etc)
        if let symbol = scope.lookup(variable, currentScopeOnly: true),
            let variableSymbol = symbol as? VariableSymbol,
            let type = variableSymbol.type as? BuiltInTypeSymbol {

            switch type {
            case .integer:
                switch value {
                case .integer(let value):
                    integerMemory[variable] = value
                case .real:
                    fatalError("Cannot assign Real value to Int variable \(variable)")
                }
            case .real:
                switch value {
                case .integer(let value):
                    realMemory[variable] = Double(value)
                case .real(let value):
                    realMemory[variable] = value
                }
            }
            return
        }

        // previous scope, eg global
        previousFrame!.set(variable: variable, value: value)
    }

    func get(variable: String) -> Number {
        // variable define in current scole (procedure declataion, etc)
        if let symbol = scope.lookup(variable, currentScopeOnly: true),
            let variableSymbol = symbol as? VariableSymbol,
            let type = variableSymbol.type as? BuiltInTypeSymbol {

            switch type {
            case .integer:
                return .integer(integerMemory[variable]!)
            case .real:
                return .real(realMemory[variable]!)
            }
        }

        // previous scope, eg global
        return previousFrame!.get(variable: variable)
    }
}
