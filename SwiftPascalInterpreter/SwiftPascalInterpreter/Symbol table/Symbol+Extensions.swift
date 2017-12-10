//
//  Symbol+Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension BuiltInType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .integer:
            return "INTEGER"
        case .real:
            return "REAL"
        }
    }
}

extension Symbol: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .builtIn(type):
            return type.description
        case let .variable(name: name, type: type):
            return "<\(name):\(type)>"
        }
    }
}
