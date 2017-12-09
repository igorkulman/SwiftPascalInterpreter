# Pascal interpreter written in Swift
One day hopefully a simple Swift interpreter for the Pascal language inspired by the [Let’s Build A Simple Interpreter](https://ruslanspivak.com/lsbasi-part1/) article series.

## Implemented so far

Lexer, parser and interpreter for the following grammar

````    
program : PROGRAM variable SEMI block DOT

block : declarations compound_statement

declarations : VAR (variable_declaration SEMI)+
            | empty

variable_declaration : ID (COMMA ID)* COLON type_spec

type_spec : INTEGER

compound_statement : BEGIN statement_list END

statement_list : statement
               | statement SEMI statement_list

statement : compound_statement
          | assignment_statement
          | empty

assignment_statement : variable ASSIGN expr

empty :

expr : term ((PLUS | MINUS) term)*

term : factor ((MUL | INTEGER_DIV | FLOAT_DIV) factor)*

factor : PLUS factor
       | MINUS factor
       | INTEGER_CONST
       | REAL_CONST
       | LPAREN expr RPAREN
       | variable

variable: ID
````

## Try it out

There is a Swift playground in the project where you can try out the lexer, parser and the interpreter. The lexer shows the tokens recognized, the parses prints the abstract syntax tree of the program and interpreter prints the resulting memory state.

![Playground](https://github.com/igorkulman/SwiftPascalInterpreter/raw/master/playground.png)
