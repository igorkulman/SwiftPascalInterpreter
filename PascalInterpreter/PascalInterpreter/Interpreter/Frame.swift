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
    var booleanMemory: [String: Bool] = [:]
    var stringMemory: [String: String] = [:]
    let scope: ScopedSymbolTable
    let previousFrame: Frame?
    var returnValue: Value = .none

    init(scope: ScopedSymbolTable, previousFrame: Frame?) {
        self.scope = scope
        self.previousFrame = previousFrame
    }

    func remove(variable: String) {
        if let symbol = scope.lookup(variable, currentScopeOnly: true),
            let variableSymbol = symbol as? VariableSymbol,
            let type = variableSymbol.type as? BuiltInTypeSymbol {

            switch type {
            case .integer:
                integerMemory.removeValue(forKey: variable)
            case .real:
                realMemory.removeValue(forKey: variable)
            case .boolean:
                booleanMemory.removeValue(forKey: variable)
            case .string:
                stringMemory.removeValue(forKey: variable)
            }
        }
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

            switch type {
            case .integer:
                switch value {
                case let .number(number):
                    switch number {
                    case let .integer(value):
                        integerMemory[variable] = value
                    case .real:
                        fatalError("Cannot assign Real value to Int variable \(variable)")
                    }
                default:
                    fatalError("Cannot assign \(value) to Int variable \(variable)")
                }
            case .real:
                switch value {
                case let .number(number):
                    switch number {
                    case let .integer(value):
                        realMemory[variable] = Double(value)
                    case let .real(value):
                        realMemory[variable] = value
                    }
                default:
                    fatalError("Cannot assign \(value) to Real variable \(variable)")
                }
            case .boolean:
                switch value {
                case let .boolean(boolean):
                    booleanMemory[variable] = boolean
                default:
                    fatalError("Cannot assign \(value) value to Boolean variable \(variable)")
                }
            case .string:
                switch value {
                case let .string(string):
                    stringMemory[variable] = string
                default:
                    fatalError("Cannot assign \(value) value to String variable \(variable)")
                }
            }
            return
        }

        // previous scope, eg global
        previousFrame!.set(variable: variable, value: value)
    }

    func get(variable: String) -> Value {
        // variable define in current scole (procedure declataion, etc)
        if let symbol = scope.lookup(variable, currentScopeOnly: true),
            let variableSymbol = symbol as? VariableSymbol,
            let type = variableSymbol.type as? BuiltInTypeSymbol {

            switch type {
            case .integer:
                return .number(.integer(integerMemory[variable]!))
            case .real:
                return .number(.real(realMemory[variable]!))
            case .boolean:
                return .boolean(booleanMemory[variable]!)
            case .string:
                return .string(stringMemory[variable]!)
            }
        }

        // previous scope, eg global
        return previousFrame!.get(variable: variable)
    }
}
