%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

int yylex(void);
void yyerror(const char *s);
%}

%union {
    int num;
    char *str;
}

%token <num> NUM
%token <str> ID
%token INT ASSIGN PLUS SEMI
%type <num> expr

%%

program:
    program stmt
    | /* empty */
    ;

stmt:
    INT ID SEMI
        { addSymbol($2, "int"); }
    | ID ASSIGN expr SEMI
        {
            if (!lookupSymbol($1)) {
                printf("Semantic Error: Variable '%s' used before declaration\n", $1);
            }
        }
    ;

expr:
    NUM
        { $$ = $1; }
    | ID
        {
            if (!lookupSymbol($1)) {
                printf("Semantic Error: Variable '%s' used before declaration\n", $1);
            }
        }
    | expr PLUS expr
        { /* Could do type checking here later */ }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter code:\n");
    yyparse();
    return 0;
}
