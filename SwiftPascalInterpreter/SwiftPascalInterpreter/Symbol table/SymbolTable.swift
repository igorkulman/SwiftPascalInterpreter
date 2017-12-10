//
//  SymbolTable.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class SymbolTable {
    private var symbols: [String: Symbol] = [:]

    init() {
        define(.builtIn(.integer))
        define(.builtIn(.real))
    }

    func define(_ symbol: Symbol) {
        switch symbol {
        case .builtIn:
            symbols[symbol.description] = symbol
        case let .variable(name: name, type: _):
            symbols[name] = symbol
        }
    }

    func lookup(_ name: String) -> Symbol? {
        return symbols[name]
    }

    public func printState() {
        print("Symbols: \(symbols.values.map({ $0.description }))")
    }
}

extension SymbolTable: Equatable {
    public static func == (lhs: SymbolTable, rhs: SymbolTable) -> Bool {
        if lhs.symbols.keys != rhs.symbols.keys {
            return false
        }

        for key in lhs.symbols.keys where lhs.symbols[key] != rhs.symbols[key] {
            return false
        }

        return true
    }
}
