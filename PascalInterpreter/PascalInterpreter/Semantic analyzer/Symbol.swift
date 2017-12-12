//
//  Symbol.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public enum BuiltInType {
    case integer
    case real
}

public indirect enum Symbol {
    case builtIn(BuiltInType)
    case variable(name: String, type: Symbol)
    case procedure(name: String, params: [Symbol])
}
