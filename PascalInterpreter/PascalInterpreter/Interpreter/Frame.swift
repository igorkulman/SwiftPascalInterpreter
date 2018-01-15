//
//  Frame.swift
//  PascalInterpreter
//
//  Created by Igor Kulman on 13/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

class Frame {
    var scalars: [String: Value] = [:]
    var arrays: [String: [Value]] = [:]
    let scope: ScopedSymbolTable
    let previousFrame: Frame?
    var returnValue: Value = .none

    init(scope: ScopedSymbolTable, previousFrame: Frame?) {
        self.scope = scope
        self.previousFrame = previousFrame

        for symbol in scope.symbols {
            guard let arraySymbol = symbol.value as? ArraySymbol, let type = arraySymbol.type as? BuiltInTypeSymbol else {
                continue
            }

            switch type {
            case .integer:
                arrays[symbol.key.uppercased()] = Array(repeating: .number(.integer(0)), count: arraySymbol.endIndex - arraySymbol.startIndex + 1)
            case .real:
                arrays[symbol.key.uppercased()] = Array(repeating: .number(.real(0)), count: arraySymbol.endIndex - arraySymbol.startIndex + 1)
            case .boolean:
                arrays[symbol.key.uppercased()] = Array(repeating: .boolean(false), count: arraySymbol.endIndex - arraySymbol.startIndex + 1)
            case .string:
                arrays[symbol.key.uppercased()] = Array(repeating: .string(""), count: arraySymbol.endIndex - arraySymbol.startIndex + 1)
            }
        }
    }

    func remove(variable: String) {
        scalars.removeValue(forKey: variable.uppercased())
    }

    func set(variable: String, value: Value, index: Int) {
        if let symbol = scope.lookup(variable, currentScopeOnly: true),
            let arraySymbol = symbol as? ArraySymbol,
            let type = arraySymbol.type as? BuiltInTypeSymbol {

            let computedIndex = index - arraySymbol.startIndex
            switch (value, type) {
            case (.number(.integer), .integer):
                arrays[variable.uppercased()]![computedIndex] = value
            case let (.number(.integer(value)), .real):
                arrays[variable.uppercased()]![computedIndex] = .number(.real(Double(value)))
            case (.number(.real), .real):
                arrays[variable.uppercased()]![computedIndex] = value
            case (.boolean, .boolean):
                arrays[variable.uppercased()]![computedIndex] = value
            case (.string, .string):
                arrays[variable.uppercased()]![computedIndex] = value
            default:
                fatalError("Cannot assing \(value) to \(type)")
            }

            return
        }

        // previous scope, eg global
        previousFrame!.set(variable: variable, value: value, index: index)
    }

    func set(variable: String, value: Value) {
        // setting function return value
        if variable == scope.name && scope.level > 1 {
            returnValue = value
            return
        }

        // variable define in current scope (procedure declaraion, etc)
        if let symbol = scope.lookup(variable, currentScopeOnly: true),
            let variableSymbol = symbol as? VariableSymbol,
            let type = variableSymbol.type as? BuiltInTypeSymbol {

            switch (value, type) {
            case (.number(.integer), .integer):
                scalars[variable.uppercased()] = value
            case let (.number(.integer(value)), .real):
                scalars[variable.uppercased()] = .number(.real(Double(value)))
            case (.number(.real), .real):
                scalars[variable.uppercased()] = value
            case (.boolean, .boolean):
                scalars[variable.uppercased()] = value
            case (.string, .string):
                scalars[variable.uppercased()] = value
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
            return scalars[variable.uppercased()]!
        }

        // previous scope, eg global
        return previousFrame!.get(variable: variable)
    }

    func get(variable: String, index: Int) -> Value {
        // variable define in current scole (procedure declataion, etc)
        if let symbol = scope.lookup(variable, currentScopeOnly: true), let arraySymbol = symbol as? ArraySymbol {
            let computedIndex = index - arraySymbol.startIndex
            return arrays[variable.uppercased()]![computedIndex]
        }

        // previous scope, eg global
        return previousFrame!.get(variable: variable, index: index)
    }
}
