

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Bison generated header (after running bison -d parser.y) */
#include "parser.tab.h"

/* yylval from Bison (union) */
extern YYSTYPE yylval;

/* track the current line number (shared with parser.y) */
int line_num = 1;
%}

/* Definitions */
DIGIT       [0-9]
NONZERO     [1-9]
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT}|_)*

/* a float can be: digits '.' digits [ (E|e)(+|-) digits ]  or digits (E) etc. We'll do a robust pattern */
EXP         ([eE][+-]?{DIGIT}+)
FLOAT1      ({DIGIT}+"."{DIGIT}+{EXP}?|{DIGIT}+"."{DIGIT}*{EXP}|{DIGIT}+{EXP})

%%


[ \t\r]+          {}
\n                { line_num++; }

"//".*            { } 

"/*"([^*]|\*+[^*/])*\*+"/"    { 
                    char *p = yytext;
                    while ((p = strchr(p, '\n')) != NULL) { line_num++; p++; }
                  }



"if"           { return IF; }
"else"         { return ELSE; }
"func"         { return FUNC; }
"while"        { return WHILE; }
"return"       { return RETURN; }
"read"         { return READ; }
"write"        { return WRITE; }
"class"        { return CLASS; }
"implement"    { return IMPLEMENT; }


"integer"      { return INTEGER_K; }
"float"        { return FLOAT_K; }
"self"         { return SELF; }
"isa"          { return ISA; }
"construct"    { return CONSTRUCT; }
"private"      { return PRIVATE; }
"then"         { return THEN; }
"public"       { return PUBLIC; }
"local"        { return LOCAL; }
"void"         { return VOID; }
"attribute"    { return ATTRIBUTE; }


"and"          { return AND_OP; }
"or"           { return OR_OP; }
"not"          { return NOT_OP; }


":="           { return ASSIGN; }
"=>"           { return ARROW; }
"<="           { return LE; }
">="           { return GE; }
"=="           { return EQ; }
"<>"           { return NE; }


{FLOAT1}       { yylval.lexeme = strdup(yytext); return FLOAT; }
{DIGIT}+       { yylval.lexeme = strdup(yytext); return INTEGER; }


{ID}           { yylval.lexeme = strdup(yytext); return ID; }


"("            { return '('; }
")"            { return ')'; }
"{"            { return '{'; }
"}"            { return '}'; }
"["            { return '['; }
"]"            { return ']'; }
";"            { return ';'; }
","            { return ','; }
":"            { return ':'; }
"."            { return '.'; }
"+"            { return '+'; }
"-"            { return '-'; }
"*"            { return '*'; }
"/"            { return '/'; }
"<"            { return '<'; }
">"            { return '>'; }


.              { fprintf(stderr, "Error: Unrecognized character '%s' on line %d\n", yytext, line_num); }

%%

int yywrap(void) { return 1; }
