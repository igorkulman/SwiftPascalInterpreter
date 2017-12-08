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

let parser = Parser("5 - - -2")
print(parser.expr())

let rpn = RPN("(5 + 3) * 12 / 3")
rpn.eval()

let ln = LISPNotation("(2 + 3 * 5)")
ln.eval()
