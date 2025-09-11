%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define the Token struct here, before %union
typedef struct {
    char *lexeme;
    int line_number;
} Token;

// Forward declarations
int yylex(void);
void yyerror(const char *s);
%}

// Define YYSTYPE as our Token wrapper
%union {
    Token token;
}

// Example tokens
%token <token> IDENTIFIER NUMBER

%%

program:
      IDENTIFIER { printf("Identifier: %s (line %d)\n", $1.lexeme, $1.line_number); free($1.lexeme); }
    | NUMBER     { printf("Number: %s (line %d)\n", $1.lexeme, $1.line_number); free($1.lexeme); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
