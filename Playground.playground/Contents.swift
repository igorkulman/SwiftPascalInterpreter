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

    function Factorial(number: Integer): Integer;
    begin
    if (number > 1) then
        Factorial := number * Factorial(number-1)
    else
        Factorial := 1
    end;

    begin { Main }
    result := Factorial(6);
    writeln(result)
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
