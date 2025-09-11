%{
#include <stdio.h>
#include "token.h"
#include "symbol_table.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

%union {
    Token* token;
}

%token <token> TOK_KEYWORD TOK_IDENTIFIER TOK_NUMBER TOK_OPERATOR TOK_SYMBOL TOK_UNKNOWN

%%

program:
    program statement
    | statement
    ;

statement:
    TOK_KEYWORD TOK_IDENTIFIER TOK_OPERATOR TOK_NUMBER TOK_SYMBOL {
        printf("Parsed declaration: %s %s = %s;\n",
               $1->lexeme, $2->lexeme, $4->lexeme);
    }
    ;

%%

void yyerror(const char* s) {
    printf("Error: %s\n", s);
}
