//: Playground - noun: a place where people can play

import Foundation
import SwiftPascalInterpreter

let lexer = Lexer("2 * (7 + 3) ")
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()

let interpeter = Interpreter("2 * (7 + 3) ")
interpeter.expr()

let parser = Parser("2*7+3")
print(parser.expr().asString)
