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
    let enclosingScope: ScopedSymbolTable?

    init(name: String, level: Int, enclosingScope: ScopedSymbolTable?) {
        self.name = name
        self.level = level
        self.enclosingScope = enclosingScope

        insert(.builtIn(.integer))
        insert(.builtIn(.real))
    }

    func insert(_ symbol: Symbol) {
        symbols[symbol.name] = symbol
    }

    func lookup(_ name: String, currentScopeOnly: Bool = false) -> Symbol? {
        if let symbol = symbols[name] {
            return symbol
        }

        if currentScopeOnly {
            return nil
        }

        return enclosingScope?.lookup(name)
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
            case (.procedure, .procedure):
                return lhs.key < rhs.key
            case (.procedure, _):
                return false
            case (_, .procedure):
                return true
            }
        }) {
            lines.append("\(pair.key.padding(toLength: 7, withPad: " ", startingAt: 0)): \(pair.value)")
        }
        return lines.reduce("", { $0 + "\n" + $1 })
    }
}
