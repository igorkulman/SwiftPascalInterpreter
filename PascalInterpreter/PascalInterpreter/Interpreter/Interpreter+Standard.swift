//
//  Interpreter+Standard.swift
//  PascalInterpreter
//
//  Created by Igor Kulman on 17/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension Interpreter {
    func callBuiltInProcedure(procedure: String, params: [AST], frame: Frame) -> Value {
        switch procedure.uppercased() {
        case "WRITE":
            write(params: params, newLine: false)
            return .none
        case "WRITELN":
            write(params: params, newLine: true)
            return .none
        case "READ":
            read(params: params, frame: frame)
            return .none
        default:
            fatalError("Implement built in procedure \(procedure)")
        }
    }

    func write(params: [AST], newLine: Bool) {
        var s = ""
        for param in params {
            let value = eval(node: param)
            switch value {
            case let .boolean(value):
                s += value ? "TRUE" : "FALSE"
            case let .number(number):
                switch number {
                case let .integer(value):
                    s += String(value)
                case let .real(value):
                    s += String(value)
                }
            case let .string(value):
                s += value
            case .none:
                fatalError("Cannot use WRITE with expression without a value")
            }
        }
        if newLine {
            print(s)
        } else {
            print(s, terminator: "")
        }
    }

    func read(params: [AST], frame: Frame) {
        guard let line = readLine() else {
            fatalError("Empty input")
        }

        let parts = line.components(separatedBy: CharacterSet.whitespaces)
        for i in 0 ... params.count - 1 {
            let param = params[i]
            guard let variable = param as? Variable else {
                fatalError("READ parameter must be a variable")
            }
            guard let symbol = frame.scope.lookup(variable.name), let variableSymbol = symbol as? VariableSymbol, let type = variableSymbol.type as? BuiltInTypeSymbol else {
                fatalError("Symbol(variable) not found '\(variable.name)'")
            }
            switch type {
            case .integer:
                frame.set(variable: variable.name, value: .number(.integer(Int(parts[i])!)))
            case .real:
                frame.set(variable: variable.name, value: .number(.real(Double(parts[i])!)))
            case .boolean:
                frame.set(variable: variable.name, value: .boolean(Bool(parts[i])!))
            case .string:
                frame.set(variable: variable.name, value: .string((parts[i])))
            }
        }
    }
}
