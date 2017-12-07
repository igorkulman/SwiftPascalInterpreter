//
//  Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension Character {
    var int: Int {
        return Int(String(self)) ?? 0
    }
}

extension Token: Equatable {
    public static func ==(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case (.operation(let left), .operation(let right)):
            return left == right
        case (.eof, .eof):
            return true
        case (.integer(let left), .integer(let right)):
            return left == right
        default:
            return false
        }
    }
}

extension Operation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minus:
            return "minus"
        case .plus:
            return "plus"
        case .mult:
            return "mult"
        case .div:
            return "div"
        }
    }
}
