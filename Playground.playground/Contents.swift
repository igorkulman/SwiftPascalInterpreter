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
    var result: integer;

    procedure Factorial(number: Integer);
    begin
    if (number = 1) then
        result:=result
    else
    begin
        result := result * number;
        Factorial(number-1)
    end
    end;

    begin { Main }
    result := 1;
    Factorial(6);
    end.  { Main }
    """

let parser = Parser(program)
let node = parser.parse()
node.printTree()
print("")

let analyzer = SemanticAnalyzer()
let result = analyzer.analyze(node: node)
print(result)

let interpreter = Interpreter(program)
interpreter.interpret()
print("")
interpreter.printState()
