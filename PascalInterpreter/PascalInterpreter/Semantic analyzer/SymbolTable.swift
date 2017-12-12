//
//  SymbolTable.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class ScopedSymbolTable {
    private var symbols: [String: Symbol] = [:]

    let name: String
    let level: Int

    init(name: String, level: Int) {
        self.name = name
        self.level = level

        let integer = Symbol.builtIn(.integer)
        let real = Symbol.builtIn(.real)
        symbols[integer.description] = integer
        symbols[real.description] = real
    }

    func insert(_ symbol: Symbol) {
        guard case let .variable(name: name, type: _) = symbol else {
            fatalError("Cannot insert built in type \(symbol), only variables")
        }

        symbols[name] = symbol
    }

    func lookup(_ name: String) -> Symbol? {
        return symbols[name]
    }
}

extension ScopedSymbolTable: Equatable {
    public static func == (lhs: ScopedSymbolTable, rhs: ScopedSymbolTable) -> Bool {
        if lhs.symbols.keys != rhs.symbols.keys {
            return false
        }

        for key in lhs.symbols.keys where lhs.symbols[key] != rhs.symbols[key] {
            return false
        }

        return true
    }
}

extension ScopedSymbolTable: CustomStringConvertible {
    public var description: String {
        var lines = ["SCOPE (SCOPED SYMBOL TABLE)", "==========================="]
        lines.append("Scope name    : \(name)")
        lines.append("Scope level   : \(level)")
        lines.append("Scope (Scoped symbol table) contents")
        lines.append("------------------------------------")
        for pair in symbols.sorted(by: { lhs, rhs -> Bool in
            switch (lhs.value, rhs.value) {
            case (.builtIn, .builtIn):
                return lhs.key < rhs.key
            case (.builtIn, .variable):
                return true
            case (.variable, .builtIn):
                return false
            case (.variable, .variable):
                return lhs.key < rhs.key
            }
        }) {
            lines.append("\(pair.key.padding(toLength: 7, withPad: " ", startingAt: 0)): \(pair.value)")
        }
        return lines.reduce("", { $0 + "\n" + $1 })
    }
}
