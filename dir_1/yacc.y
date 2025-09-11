%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);

int vars[26];  /* variable store: a=0, b=1, ... */
%}

%union {
    int num;
    char *id;
}

%token WHILE IF THEN ELSE PRINT
%token <num> NUMBER
%token <id> IDENTIFIER
%token ASSIGN PLUS MINUS SEMICOLON LBRACE RBRACE LPAREN RPAREN
%token EQ GT LT

%type <num> expression condition 


%%

program : statement_list { }
        ;

statement_list : statement_list statement
               | statement
               ;

statement : IDENTIFIER ASSIGN expression SEMICOLON
            { vars[$1[0]-'a'] = $3; }
          | WHILE LPAREN condition RPAREN LBRACE statement_list RBRACE
            {
                while ($3) {
                    /* execute loop body */
                }
            }
          | IF condition THEN statement ELSE statement
          | PRINT IDENTIFIER SEMICOLON
            { printf("%d\n", vars[$2[0]-'a']); }
          ;

expression : expression PLUS expression { $$ = $1 + $3; }
           | expression MINUS expression { $$ = $1 - $3; }
           | NUMBER { $$ = $1; }
           | IDENTIFIER { $$ = vars[$1[0]-'a']; }
           ;

condition : expression GT expression { $$ = $1 > $3; }
          | expression LT expression { $$ = $1 < $3; }
          | expression EQ expression { $$ = $1 == $3; }
          ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
