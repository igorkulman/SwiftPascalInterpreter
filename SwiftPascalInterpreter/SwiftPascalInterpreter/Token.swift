//
//  Token.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public enum Operation {
    case plus
    case minus
    case mult
    case div
}

public enum Parenthesis {
    case left
    case right
}

public enum Token {
    case integer(Int)
    case operation(Operation)
    case eof
    case parenthesis(Parenthesis)
}
