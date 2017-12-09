//
//  Token.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 06/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public enum Token {
    case plus
    case minus
    case mult
    case integerDiv
    case floatDiv
    case eof
    case lparen
    case rparen
    case begin
    case end
    case id(String)
    case dot
    case assign
    case semi
    case program
    case varDef
    case colon
    case coma
    case integer
    case real
    case integerConst(Int)
    case realConst(Double)
}
