# Pascal interpreter written in Swift
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Swift Version](https://img.shields.io/badge/Swift-4-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Twitter](https://img.shields.io/badge/twitter-@igorkulman-blue.svg)](http://twitter.com/igorkulman)

Simple Swift interpreter for the Pascal language inspired by the [Let’s Build A Simple Interpreter](https://ruslanspivak.com/lsbasi-part1/) article series.

There is a Swift playground in the project where you can try out the lexer, parser and the interpreter. The lexer shows the tokens recognized, the parses prints the abstract syntax tree of the program and interpreter prints the resulting memory state.

![Playground](https://github.com/igorkulman/SwiftPascalInterpreter/raw/master/playground.png)

## Scructure

### Lexer

The [Lexer](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreter/Lexer/Lexer.swift) reads the Pascal program as `String` (a sequence of characters) and converts it into a sequence of [Tokens](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreter/Lexer/Token.swift). You can see the result by trying it our in the Playground or on the [unit tests](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreterTests/LexerTests.swift).

### Parser

The [Parser](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreter/Parser/Parser.swift) reads the sequence of tokens produced by the Lexer and builds an [Abstract Syntax Tree representation](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreter/Parser/AST.swift)(AST for short) of the Pascal program according to the [grammar](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/grammar.md). 

You can see what the AST looks like in the [unit tests](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreterTests/ParserTests.swift) or in the Playground where you can also use the `printTree()` method on any AST to see its visual representation printed into the console.

### Semantic analyzer

The [Semantic analyzer](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreter/Semantic%20analyzer/Semanticanalyzer.swift) does static semantic checks on the Pascal program AST. It currently checks if all the used variables are declared beforehand and if there are any duplicate declarations. The result of semantic analysis is a [Symbol table](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreter/Semantic%20analyzer/SymbolTable.swift) that holds all the symbols used by a Pascal program, currently built in types (Integer, Real) and declared variable names. 

### Interpreter

The [Interpreter](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreter/Interpreter/Interpreter.swift) reads the AST representing the Pascal program from Parser and interprets it by walking the AST recursively. It can handle basic Pascal programs with declarations and arithmetics on integers and reals. 

At the end of the Pascal program interpretation you can check the resulting memory state (see [unit tests](https://github.com/igorkulman/SwiftPascalInterpreter/blob/master/PascalInterpreter/PascalInterpreterTests/InterpreterTests.swift)) or print it in the Playground using `printState()`.
