//
//  Value+Extensions.swift
//  PascalInterpreter
//
//  Created by Igor Kulman on 25/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension Value: Equatable {
    static func == (lhs: Value, rhs: Value) -> Bool {
        switch (lhs, rhs) {
        case let (.number(left), .number(right)):
            return left == right
        case let (.boolean(left), .boolean(right)):
            return left == right
        case let (.string(left), .string(right)):
            return left == right
        default:
            return false
        }
    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "NIL"
        case .boolean(let value):
            return "BOOLEAN(\(value))"
        case .string(let value):
            return "STRING(\(value))"
        case .number(let number):
            switch number {
            case .integer(let value):
                return "INTEGER(\(value)"
            case .real(let value):
                return "REAL(\(value)"
            }
        }
    }
}
