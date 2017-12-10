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

    /**
     Unary plus
     */
    static prefix func + (left: Number) -> Number {
        switch left {
        case let .integer(value):
            return .integer(+value)
        case let .real(value):
            return .real(+value)
        }
    }

    /**
     Unary minus
     */
    static prefix func - (left: Number) -> Number {
        switch left {
        case let .integer(value):
            return .integer(-value)
        case let .real(value):
            return .real(-value)
        }
    }

    /**
     Binary plus

     Int + Int -> Int
     Real + Real -> Real
     Int + Real -> Real
     */
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

    /**
     Binary minus

     Int - Int -> Int
     Real - Real -> Real
     Int - Real -> Real
     */
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

    /**
     Binary multiplication

     Int * Int -> Int
     Real * Real -> Real
     Int * Real -> Real
     */
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

    /**
     Binary float division

     Int / Int -> Real
     Real / Real -> Real
     Int / Real -> Real
     Real / Int -> Real
     */
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

    /**
     Binary integer division

     Int ‖ Int -> Int
     Real ‖ Real -> error
     Int ‖ Real -> error
     Real ‖ Int -> error
     */
    static func ‖ (left: Number, right: Number) -> Number {
        switch (left, right) {
        case let (.integer(left), .integer(right)):
            return .integer(left / right)
        default:
            fatalError("Integer division DIV can only be applied to two integers")
        }
    }
}
