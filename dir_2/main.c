#include <stdio.h>
#include "symbol_table.h"

extern FILE* yyin;
extern int yyparse();

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: %s <sourcefile>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Could not open file");
        return 1;
    }

    yyparse();
    print_symbol_table();
    return 0;
}
