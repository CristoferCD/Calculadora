#include <stdio.h>
#include <calculadora.tab.h>

int main() {
    printf("Calculadora multifunción, escribe \"help\" para ver la ayuda\n");
    symbolTable_init();
    return yyparse();
}