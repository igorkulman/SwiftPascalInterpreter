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

public enum Symbol {
    case builtIn(BuiltInType)
    indirect case variable(name: String, type: Symbol)
}
