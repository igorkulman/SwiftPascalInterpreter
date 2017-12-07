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

let interpeter = Interpreter("7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)")
interpeter.eval()

let parser = Parser("2 * (7 + 3) ")
print(parser.expr())
