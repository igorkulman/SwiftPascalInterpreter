//
//  SymbolTable.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public class SymbolTable {
    private var symbols: [String: Symbol] = ["INTEGER": .builtIn(.integer),
                                             "REAL": .builtIn(.real)]

    public init() {

    }

    public func define(_ symbol: Symbol) {
        guard case let .variable(name: name, type: _) = symbol else {
            fatalError("Cannot define symbol \(symbol)")
        }

        symbols[name] = symbol
    }

    public func lookup(_ name: String) -> Symbol? {
        print("Lookup: \(name)")
        return symbols[name]
    }

    public func printState() {
        print("Symbols: \(symbols.values.map({$0.description}))")
    }
}
