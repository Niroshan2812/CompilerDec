#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

static Symbol* head = NULL;

void insert_symbol(const char* name, const char* type, int line) {
    Symbol* s = (Symbol*)malloc(sizeof(Symbol));
    s->name = strdup(name);
    s->type = strdup(type);
    s->line = line;
    s->next = head;
    head = s;
}

Symbol* lookup_symbol(const char* name) {
    Symbol* temp = head;
    while (temp) {
        if (strcmp(temp->name, name) == 0) return temp;
        temp = temp->next;
    }
    return NULL;
}

void print_symbol_table() {
    printf("\n--- Symbol Table ---\n");
    Symbol* temp = head;
    while (temp) {
        printf("Name: %-10s Type: %-10s Line: %d\n",
               temp->name, temp->type, temp->line);
        temp = temp->next;
    }
}
