````
program : PROGRAM variable SEMI block DOT

block : declarations compound_statement

declarations : (VAR (variable_declaration SEMI)+)*
             | (PROCEDURE ID (LPAREN formal_parameter_list RPAREN)? SEMI block SEMI)*
             | (FUNCTION ID (LPAREN formal_parameter_list RPAREN)? COLON type_spec SEMI block SEMI)*
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
          | if_else_statement
          | assignment_statement
          | empty

function_call : id LPAREN (factor (factor COLON)* )* RPAREN  (COLON type_spec){0,1}       

if_else_statement : IF condition statement
                  | IF condition THEN statement ELSE statement

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
       | function_call

variable: ID
````
