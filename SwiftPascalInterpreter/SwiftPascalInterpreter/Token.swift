//
//  Token.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public enum Token {
    case integer(Int)
    case plus
    case eof
    
    var description: String {
        switch self {
        case .integer(let int):
            return "INTEGER(\(int))"
        case .plus:
            return "PLUS"
        case .eof:
            return "EOF"
        }
    }
}
