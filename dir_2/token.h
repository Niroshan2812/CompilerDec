#ifndef TOKEN_H
#define TOKEN_H

// Different type of tokens
typedef enum {
    TOK_KEYWORD, 
    TOK_IDENTIFIER, 
    TOK_NUMBER, 
    TOK_OPERATOR, 
    TOK_SYMBOL, 
    TOK_UNKNOWN
} TokenType; 

// token Structure
typedef struct{
    TokenType type;
    char* lexeme;
    int line;
    int column;
} Token;

// function prototypes
Token* create_token (TokenType type, const char* lexeme, int line, int column); 
void print_token(Token* token); 

#endif
