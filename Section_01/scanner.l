
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*Bison generated header */
#include "parser.tab.h"

/*yylval from Bison*/
extern YYSTYPE yylval; 

/* track the corrent line number */
int line_num = 1; 

%}

/*Definition*/
DIGIT [0-9]
NONZERO [1-9]
LETTER [a-zA-Z]
ID {LETTER}({LETTER}|{DIGIT}|_)*

/*FLOAT can be digit '.' So fallow robost pattern */
EXP ([eE][+-]? {DIGIT}+)
FLOAT1 ({DIGIT}+ "."{DIGIT}+{EXP}? |{DIGIT}+ "."{DIGIT}*{EXP}|{DIGIT}+{EXP})

%%
[\t\r] {/*ignore wite space, tabs, carriage  returns*/}
\n {line_num++;}

/*Comments*/
/* single-line comment */
"//".* {/*ignore*/}

/* block comment */

"/*"([^*]|\*+[^*/])*\*+"/" {
     /* count newlines inside block comment for accurate line numbers */
     /* a simple approach: count '\n' occurrences in yytext */
    char *p = yytext; 
    while((p = strchr (p,'\n')) != NULL) {line_num++; p++;}
}
/* Keywords (these must come before the general ID rule) */
"if"           { return IF; }
"else"         { return ELSE; }
"func"         { return FUNC; }
"while"        { return WHILE; }
"return"       { return RETURN; }
"read"         { return READ; }
"write"        { return WRITE; }
"class"        { return CLASS; }
"implement"    { return IMPLEMENT; }

/* Reserved words in the table (some mapped to distinct token names when appropriate) */
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
/* "write" and "read" already handled; duplicates would return same token */

/* Logical/spell-out operators (treated as tokens) */
"and"          { return AND_OP; }
"or"           { return OR_OP; }
"not"          { return NOT_OP; }

/* Multi-character operators - longest-first */
":="           { return ASSIGN; }
"=>"           { return ARROW; }
"<="           { return LE; }
">="           { return GE; }
"=="           { return EQ; }
"<>"           { return NE; }

/* Numeric literals - order matters: float before integer */
{FLOAT1}       { yylval.lexeme = strdup(yytext); return FLOAT; }
{DIGIT}+       { yylval.lexeme = strdup(yytext); return INTEGER; }

/* Identifiers */
{ID}           { yylval.lexeme = strdup(yytext); return ID; }

/* Single-character punctuation/operators */
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

/* Unrecognized character */
.              { fprintf(stderr, "Error: Unrecognized character '%s' on line %d\n", yytext, line_num); }

%%

int yywrap(void){return 1;}