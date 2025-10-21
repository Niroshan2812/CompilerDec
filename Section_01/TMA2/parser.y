/* parser.y - Full parser for TMA 2 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

extern int line_num;
%}

/*
 * UNION: Defines the types of semantic values for tokens and rules.
 * For TMA 2, we don't need to pass complex data yet, so a string is enough.
 * This will be expanded in TMA 3 to build an AST.
 */
%union {
    char *lexeme;
    /* In TMA3, we'll add nodes for our Abstract Syntax Tree here, like:
     * struct AstNode *node;
     */
}

/*
 * TOKENS: Declare all terminal symbols from the lexer.
 */
%token <lexeme> ID INTEGER FLOAT
%token IF ELSE FUNC WHILE RETURN READ WRITE CLASS IMPLEMENT
%token INTEGER_K FLOAT_K SELF ISA CONSTRUCT PRIVATE THEN PUBLIC LOCAL
%token VOID ATTRIBUTE

%token ASSIGN       /* ":=" */
%token ARROW        /* "=>" */
%token LE           /* "<=" */
%token GE           /* ">=" */
%token EQ           /* "==" This was missing, added for completeness */
%token NE           /* "<>" */
%token AND_OP       /* "and" */
%token OR_OP        /* "or" */
%token NOT_OP       /* "not" */


/*
 * PRECEDENCE AND ASSOCIATIVITY:
 * This is how we resolve ambiguities.
 * Operators on the same line have the same precedence.
 * Lines higher up have lower precedence.
 */
%right ASSIGN
%left OR_OP
%left AND_OP
%left '<' '>' LE GE EQ NE  /* Relational operators */
%left '+' '-'             /* Additive operators */
%left '*' '/'             /* Multiplicative operators */
%right NOT_OP             /* Unary not */
%nonassoc THEN          /* Precedence for dangling-else */
%nonassoc ELSE          /* Solves the if-then-else ambiguity */


%%
/*
 * GRAMMAR RULES:
 * The rules are based on the language specification in the PDF.
 * The actions { ... } are currently simple print statements to confirm parsing.
 * In TMA 3, these will be replaced with code to build an AST.
 */

prog:
    /* empty */
    | prog classOrImplOrFunc { printf("Parsed a top-level declaration.\n"); }
    ;

classOrImplOrFunc:
    classDecl
    | implDef
    | funcDef
    ;

classDecl:
    CLASS ID opt_isa '{' memberDecl_list '}' ';'
    ;

opt_isa:
    /* empty */
    | ISA ID id_list
    ;

id_list:
    /* empty */
    | id_list ',' ID
    ;

memberDecl_list:
    /* empty */
    | memberDecl_list visibility memberDecl
    ;

visibility:
    PUBLIC
    | PRIVATE
    ;

memberDecl:
    funcDecl
    | attributeDecl
    ;

funcDecl:
    funcHead ';'
    ;

attributeDecl:
    ATTRIBUTE varDecl
    ;

implDef:
    IMPLEMENT ID '{' funcDef_list '}'
    ;

funcDef_list:
    /* empty */
    | funcDef_list funcDef
    ;

funcDef:
    funcHead funcBody
    ;

funcHead:
    FUNC ID '(' fParams ')' ARROW returnType
    | CONSTRUCT '(' fParams ')'
    ;

funcBody:
    '{' varDeclOrStmt_list '}'
    ;

varDeclOrStmt_list:
    /* empty */
    | varDeclOrStmt_list varDeclOrStmt
    ;

varDeclOrStmt:
    localOrStatement
    ;

localOrStatement:
    LOCAL varDecl
    | statement
    ;

varDecl:
    ID ':' type arraySize_list ';'
    ;

arraySize_list:
    /* empty */
    | arraySize_list arraySize
    ;

statement:
    assignStat ';'
    | ifStat
    | whileStat
    | readStat ';'
    | writeStat ';'
    | returnStat ';'
    | functionCall ';'
    ;

assignStat:
    variable ASSIGN expr
    ;

ifStat:
    IF '(' expr ')' THEN statBlock %prec THEN
    | IF '(' expr ')' THEN statBlock ELSE statBlock
    ;

whileStat:
    WHILE '(' expr ')' statBlock
    ;

readStat:
    READ '(' variable ')'
    ;

writeStat:
    WRITE '(' expr ')'
    ;

returnStat:
    RETURN '(' expr ')'
    ;

statBlock:
    '{' statement_list '}'
    | statement
    ;

statement_list:
    /* empty */
    | statement_list statement
    ;

expr:
    arithExpr
    | arithExpr relOp arithExpr
    ;

relOp:
    EQ | NE | '<' | '>' | LE | GE
    ;

arithExpr:
    term
    | arithExpr addOp term
    ;

addOp:
    '+' | '-' | OR_OP
    ;

term:
    factor
    | term multOp factor
    ;

multOp:
    '*' | '/' | AND_OP
    ;

factor:
    variable
    | functionCall
    | INTEGER
    | FLOAT
    | '(' arithExpr ')'
    | NOT_OP factor
    | sign factor
    ;

sign:
    '+' | '-'
    ;

variable:
    idnest_list ID indice_list
    ;

idnest_list:
    /* empty */
    | idnest_list idnest
    ;

idnest:
    ID indice_list '.'
    ;

indice_list:
    /* empty */
    | indice_list indice
    ;

indice:
    '[' arithExpr ']'
    ;

functionCall:
    idnest_list ID '(' aParams ')'
    ;

type:
    INTEGER_K
    | FLOAT_K
    | ID
    ;

returnType:
    type
    | VOID
    ;

fParams:
    /* empty */
    | fParamList
    ;

fParamList:
    fParam
    | fParamList ',' fParam
    ;

fParam:
    ID ':' type arraySize_list
    ;

aParams:
    /* empty */
    | aParamList
    ;

aParamList:
    expr
    | aParamList ',' expr
    ;

arraySize:
    '[' INTEGER ']'
    | '[' ']'
    ;

%%
/* C Code Section */

int main(void) {
    printf("Starting parse...\n");
    if (yyparse() == 0) {
        printf("Parse completed successfully!\n");
    } else {
        printf("Parse failed.\n");
    }
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error on line %d: %s\n", line_num, s);
}
