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
        case let .boolean(value):
            return "BOOLEAN(\(value))"
        case let .string(value):
            return "STRING(\(value))"
        case let .number(number):
            switch number {
            case let .integer(value):
                return "INTEGER(\(value))"
            case let .real(value):
                return "REAL(\(value))"
            }
        }
    }
}
