//
//  Naming+Extensions.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 09/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

extension Lexer: CustomStringConvertible {
    public var description: String {
        return "Lexer"
    }
}

extension Interpreter: CustomStringConvertible {
    public var description: String {
        return "Interpreter"
    }
}

extension Parser: CustomStringConvertible {
    public var description: String {
        return "Parser"
    }
}
