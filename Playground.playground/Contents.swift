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

    procedure Alpha(a, b: Integer);
    begin
    x := a + y + b;
    end;

    begin { Main }
    y:=3;
    Alpha(2, 13);
    end.  { Main }
    """

let parser = Parser(program)
let node = parser.parse()
node.printTree()
print("")

let interpreter = Interpreter(program)
interpreter.interpret()
print("")
interpreter.printState()
