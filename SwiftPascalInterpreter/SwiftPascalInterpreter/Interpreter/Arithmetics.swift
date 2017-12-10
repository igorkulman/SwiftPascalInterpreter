//
//  Arithmetics.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

/**
 Binary operator representing DIV (integer division)
 */
infix operator ‖: MultiplicationPrecedence

extension Number {
    static prefix func + (left: Number) -> Number {
        switch left {
        case let .integer(value):
            return .integer(+value)
        case let .real(value):
            return .real(+value)
        }
    }

    static prefix func - (left: Number) -> Number {
        switch left {
        case let .integer(value):
            return .integer(-value)
        case let .real(value):
            return .real(-value)
        }
    }

    static func + (left: Number, right: Number) -> Number {
        switch (left, right) {
        case let (.integer(left), .integer(right)):
            return .integer(left + right)
        case let (.real(left), .real(right)):
            return .real(left + right)
        case let (.integer(left), .real(right)):
            return .real(Double(left) + right)
        case let (.real(left), .integer(right)):
            return .real(left + Double(right))
        }
    }

    static func - (left: Number, right: Number) -> Number {
        switch (left, right) {
        case let (.integer(left), .integer(right)):
            return .integer(left - right)
        case let (.real(left), .real(right)):
            return .real(left - right)
        case let (.integer(left), .real(right)):
            return .real(Double(left) - right)
        case let (.real(left), .integer(right)):
            return .real(left - Double(right))
        }
    }

    static func * (left: Number, right: Number) -> Number {
        switch (left, right) {
        case let (.integer(left), .integer(right)):
            return .integer(left * right)
        case let (.real(left), .real(right)):
            return .real(left * right)
        case let (.integer(left), .real(right)):
            return .real(Double(left) * right)
        case let (.real(left), .integer(right)):
            return .real(left * Double(right))
        }
    }

    static func / (left: Number, right: Number) -> Number {
        switch (left, right) {
        case let (.integer(left), .integer(right)):
            return .real(Double(left) / Double(right))
        case let (.real(left), .real(right)):
            return .real(left / right)
        case let (.integer(left), .real(right)):
            return .real(Double(left) / right)
        case let (.real(left), .integer(right)):
            return .real(left / Double(right))
        }
    }

    static func ‖ (left: Number, right: Number) -> Number {
        switch (left, right) {
        case let (.integer(left), .integer(right)):
            return .integer(left / right)
        default:
            fatalError("Integer division DIV can only be applied to two integers")
        }
    }
}
