//
//  Result.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

enum Value {
    case number(Number)
    case boolean(Bool)
}

extension Value: Equatable {
    static func == (lhs: Value, rhs: Value) -> Bool {
        switch (lhs, rhs) {
        case let (.number(left), .number(right)):
            return left == right
        case let (.boolean(left), .boolean(right)):
            return left == right
        default:
            return false
        }
    }

}
