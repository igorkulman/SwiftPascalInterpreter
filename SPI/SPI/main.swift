//
//  main.swift
//  SPI
//
//  Created by Igor Kulman on 17/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

if CommandLine.arguments.count == 2 {
    let program = try String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
    let interpreter = Interpreter(program)
    interpreter.interpret()
} else {
    print("Usage: SPI program.pas")
}
