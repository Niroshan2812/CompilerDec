%{
#include "parser.tab.h"   // brings in YYSTYPE + Token
#include <string.h>

extern int yylineno;
%}

%%

[0-9]+ {
    yylval.token.lexeme = strdup(yytext);
    yylval.token.line_number = yylineno;
    return NUMBER;
}

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.token.lexeme = strdup(yytext);
    yylval.token.line_number = yylineno;
    return IDENTIFIER;
}

[ \t\r\n]+   ;   // skip whitespace
.            ;   // ignore other characters

%%

int yywrap(void) { return 1; }
