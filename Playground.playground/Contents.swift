//: Playground - noun: a place where people can play

import Foundation
import PascalInterpreter

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
        y := 20 / 7 + 3.14 + a;
    END.  {Part10AST}
    """

let parser = Parser(program)
let node = parser.parse()
print(node)
print("")

let analyzer = SemanticAnalyzer()
analyzer.analyze(node: node)

print("")

let interpreter = Interpreter(program)
interpreter.interpret()
print("")
interpreter.printState()
