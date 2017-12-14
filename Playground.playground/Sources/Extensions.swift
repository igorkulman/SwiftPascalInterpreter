import Foundation
import PascalInterpreter

extension Parser: CustomStringConvertible {
    public var description: String {
        return "PARSER"
    }
}

extension Lexer: CustomStringConvertible {
    public var description: String {
        return "LEXER"
    }
}

extension Interpreter: CustomStringConvertible {
    public var description: String {
        return "INTERPRETER"
    }
}

extension SemanticAnalyzer: CustomStringConvertible {
    public var description: String {
        return "SEMANTIC ANALYZER"
    }
}
