#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <string.h>

// A simple linked list-based symbol table entry
typedef struct Symbol {
    char *name;
    struct Symbol *next;
} Symbol;

Symbol *symbol_table_head = NULL;

void add_to_symbol_table(const char *name) {
    // Check if the symbol already exists
    Symbol *current = symbol_table_head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return; // Symbol already exists
        }
        current = current->next;
    }

    // Add new symbol
    Symbol *new_symbol = (Symbol *)malloc(sizeof(Symbol));
    if (new_symbol == NULL) {
        perror("Failed to allocate memory for symbol");
        exit(1);
    }
    new_symbol->name = strdup(name);
    new_symbol->next = symbol_table_head;
    symbol_table_head = new_symbol;
}

void print_symbol_table() {
    printf("\n--- Symbol Table ---\n");
    Symbol *current = symbol_table_head;
    while (current != NULL) {
        printf("%s\n", current->name);
        current = current->next;
    }
    printf("--------------------\n");
}

void free_symbol_table() {
    Symbol *current = symbol_table_head;
    Symbol *next;
    while (current != NULL) {
        next = current->next;
        free(current->name);
        free(current);
        current = next;
    }
    symbol_table_head = NULL;
}

#endif // SYMBOL_TABLE_H