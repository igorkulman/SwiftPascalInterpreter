````
program : PROGRAM variable SEMI block DOT

block : declarations compound_statement

declarations : (VAR (variable_declaration SEMI)+)*
             | (PROCEDURE ID (LPAREN formal_parameter_list RPAREN)? SEMI block SEMI)*
             | empty

formal_parameter_list : formal_parameters
                      | formal_parameters SEMI formal_parameter_list        
                      
formal_parameters : ID (COMMA ID)* COLON type_spec                            

variable_declaration : ID (COMMA ID)* COLON type_spec

type_spec : INTEGER

compound_statement : BEGIN statement_list END

statement_list : statement
               | statement SEMI statement_list

statement : compound_statement
		  | procedure_call
          | assignment_statement
          | empty

procedure_call : id( (factor [,])* );          

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
