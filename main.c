#include <stdio.h>
#include <calculadora.tab.h>

int main() {
    symbolTable_init();
    return yyparse();
}