// symbol_table.c 
// Store infromation about declared identifiers (like variables )
#include <stdio.h>
#include <string.h>

#define MAX_SYMBOLS 100

typedef struct {
    char name[50];
    char type[10];
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;

// Add a new symbol
void addSymbol(char *name, char *type) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            printf("Semantic Error: Redeclaration of variable '%s'\n", name);
            return;
        }
    }
    strcpy(symbolTable[symbolCount].name, name);
    strcpy(symbolTable[symbolCount].type, type);
    symbolCount++;
}

// Check if variable exists
int lookupSymbol(char *name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0)
            return 1;
    }
    return 0;
}
