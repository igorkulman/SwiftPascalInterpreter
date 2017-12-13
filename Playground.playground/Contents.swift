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
    program Main;
    var x, y: integer;

    procedure Alpha();
    var a: integer;
    begin
    a := 2;
    x := a + y;
    end;

    begin { Main }
    y:=5;
    Alpha();
    end.  { Main }
    """

let parser = Parser(program)
let node = parser.parse()
//print(node)
//print("")
/*
let analyzer = SemanticAnalyzer()
analyzer.analyze(node: node)*/

print("")

let interpreter = Interpreter(program)
interpreter.interpret()
print("")
interpreter.printState()

