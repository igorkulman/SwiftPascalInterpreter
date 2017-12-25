//
//  Frame.swift
//  PascalInterpreter
//
//  Created by Igor Kulman on 13/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

class Frame {
    var memory: [String: Value] = [:]
    let scope: ScopedSymbolTable
    let previousFrame: Frame?
    var returnValue: Value = .none

    init(scope: ScopedSymbolTable, previousFrame: Frame?) {
        self.scope = scope
        self.previousFrame = previousFrame
    }

    func remove(variable: String) {
        memory.removeValue(forKey: variable)
    }

    func set(variable: String, value: Value) {
        // setting function return value
        if variable == scope.name && scope.level > 1 {
            returnValue = value
            return
        }

        // variable define in current scole (procedure declataion, etc)
        if let symbol = scope.lookup(variable, currentScopeOnly: true),
            let variableSymbol = symbol as? VariableSymbol,
            let type = variableSymbol.type as? BuiltInTypeSymbol {

            switch (value, type) {
            case (.number(.integer), .integer ):
                memory[variable] = value
            case (.number(.integer(let value)), .real ):
                memory[variable] = .number(.real(Double(value)))
            case (.number(.real), .real ):
                memory[variable] = value
            case (.boolean, .boolean ):
                memory[variable] = value
            case (.string, .string ):
                memory[variable] = value
            default:
               fatalError("Cannot assing \(value) to \(type)")
            }

            return
        }

        // previous scope, eg global
        previousFrame!.set(variable: variable, value: value)
    }

    func get(variable: String) -> Value {
        // variable define in current scole (procedure declataion, etc)
        if scope.lookup(variable, currentScopeOnly: true) != nil {
            return memory[variable]!
        }

        // previous scope, eg global
        return previousFrame!.get(variable: variable)
    }
}
