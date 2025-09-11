%{
#include "token.h"
#include "symbol_table.h"
#include "parser.tab.h"

int line = 1, column = 1;
%}

%%

"int"      { yylval.token = create_token(TOK_KEYWORD, yytext, line, column); return TOK_KEYWORD; }
"float"    { yylval.token = create_token(TOK_KEYWORD, yytext, line, column); return TOK_KEYWORD; }


[a-zA-Z_][a-zA-Z0-9_]*  { yylval.token = create_token(TOK_IDENTIFIER, yytext, line, column);
                          insert_symbol(yytext, "identifier", line);
                          return TOK_IDENTIFIER; }


[0-9]+                  { yylval.token = create_token(TOK_NUMBER, yytext, line, column); return TOK_NUMBER; }


"="                     { yylval.token = create_token(TOK_OPERATOR, yytext, line, column); return TOK_OPERATOR; }


";"                     { yylval.token = create_token(TOK_SYMBOL, yytext, line, column); return TOK_SYMBOL; }

[ \t]+                  { column += yyleng; }
\n                      { line++; column = 1; }

.                       { yylval.token = create_token(TOK_UNKNOWN, yytext, line, column); return TOK_UNKNOWN; }

%%

int yywrap() { return 1; }
