//: Playground - noun: a place where people can play

import Foundation
import SwiftPascalInterpreter

let lexer = Lexer("BEGIN a := 2; END.")
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()
lexer.getNextToken()

let program =
"""
PROGRAM Part10AST;
VAR
   a, b : INTEGER;
   y    : REAL;

BEGIN {Part10AST}
   a := 2;
   b := 10 * a + 10 * a DIV 4;
   y := 20 / 7 + 3.14;
END.  {Part10AST}
"""

let parser = Parser(program)
print(parser.parse())
print("")

let interpreter = Interpreter(program)
interpreter.interpret()
interpreter.printState()

print("")
let symbolTable = SymbolTable()
symbolTable.define(.variable(name: "x", type: .builtIn(.integer)))
symbolTable.define(.variable(name: "y", type: .builtIn(.real)))
symbolTable.printState()
