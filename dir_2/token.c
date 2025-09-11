#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "token.h"

Token* create_token (TokenType type, const char* lexeme, int line, int column){
    Token* t =  (Token*) malloc (sizeof(Token)); 
    t->type = type; 
    t->lexeme = strdup(lexeme);
    t->line = line; 
    t->column = column; 

    return t;
}

void print_token(Token* token){
    const char* type_names[] = {
         "KEYWORD", "IDENTIFIER", "NUMBER", "OPERATOR", "SYMBOL", "UNKNOWN"
   
    }; 
    printf("Token: %-10s Lexeme: %-10s Location: (%d,%d)\n",
           type_names[token->type], token->lexeme, token->line, token->column);
}