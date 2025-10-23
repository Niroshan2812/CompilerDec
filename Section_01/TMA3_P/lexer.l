%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"int"       { return INT; }
[a-zA-Z_][a-zA-Z0-9_]*   { yylval.str = strdup(yytext); return ID; }
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
";"         { return SEMI; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
[ \t\n]+    ;   // ignore whitespace
.           { printf("Unknown character: %s\n", yytext); }
%%
int yywrap(void){
    return 1; 
}