#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct Symbol{
    char* name; 
    char* type;
    int line; 
    struct Symbol* next; 

} Symbol;

void insert_symbol(const char* name, const char* type, int line);
Symbol* lookup_symbol(const char* name);
void print_symbol_table();

#endif