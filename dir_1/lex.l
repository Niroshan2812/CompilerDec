%{
#include "yacc.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"while" {return WHILE; }
"if" {return IF;}
"then" {return THEN;}
"else" {return ELSE; }
"print" {return PRINT; }

[0-9]+ {yylval.num = atoi (yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* {yylval.id = strdup(yytext); return IDENTIFIER; }

"=="            { return EQ; }
">"             { return GT; }
"<"             { return LT; }
"="             { return ASSIGN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
";"             { return SEMICOLON; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"("             { return LPAREN; }
")"             { return RPAREN; }

[ \t\n] ; 
. {return yytext[0];}
%%

int yywrap() {return 1; }
