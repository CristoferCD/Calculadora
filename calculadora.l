%{
	#include <stdlib.h>
	#include "calculadora.tab.h"
	#include "../tablaSimbolos.h"
	#include "../funciones.h"

	extern YYSTYPE yylval;
%}

/* Letters and digits */

letter 		[a-zA-Z]
decimal_digit 	[0-9]
octal_digit 	[0-7]
hex_digit 	[0-9A-Fa-f]

identifier 	{letter}*

int_lit 	({decimal_lit})|({octal_lit})|({hex_lit})
decimal_lit 	[1-9]{decimal_digit}*
octal_lit	0{octal_digit}*
hex_lit		0[xX]?{hex_digit}+

/* Floating-point literals */

float_lit	({decimals}\.{decimals}?{exponent}?)|({decimals}{exponent})|(\.{decimals}{exponent}?)
decimals	{decimal_digit}+
exponent	[eE][+-]?{decimals}
imaginary_lit	({decimals}|{float_lit})i

%%

"exit"			{ return QUIT; }
"help"          { printHelp(); }
"input ".*"\n"  { loadFile(yytext); }
{imaginary_lit}		/* not implemented */
{float_lit}		{ yylval.numValue = atof(yytext); /*printf("[float]Getting llval %lf and text %s\n", yylval.numValue, yytext);*/ return NUMBER; }
{int_lit}		{ yylval.numValue = atoi(yytext); /*printf("[int]Getting llval %d and text %s\n", yylval.numValue, yytext);*/ return NUMBER; }
{identifier}	{ return ts_get(&yylval, yytext); }
"\n"			{ return LINEBREAK; }
[\t ]           /* Ignore whitespaces and tabs */
.				{ return *yytext; }
<<EOF>>         { yypop_buffer_state();
                  /* Make sure we stop if the EOF is the original input. */
                  if (!YY_CURRENT_BUFFER) { yyterminate(); } }

%%

int ts_get (YYSTYPE *yylval, char* yytext) {
	itemNode* nodeFromTable = symbolTable_getComponent(yytext);
	if (nodeFromTable != NULL) {
		yylval->numValue = nodeFromTable->numValue;
		yylval->symNode = nodeFromTable;
		// Id can be ID or FUNCTION
		int id = nodeFromTable->id;
		return id;
	} else { // Not found in symbol table -> new id.
		itemNode* newNode;
		node_create(&newNode);
		newNode->key = strdup(yytext);
		newNode->id = ID;
		newNode->numValue = 0;
		symbolTable_insert(newNode);
		yylval->symNode = newNode;
		return ID;
	}	
}

void printHelp() {
    printf("-- CALCULADORA MULTIFUNCIÓN --\n");
    printf("comandos:\n");
    printf("\texit:\t Salir de la calculadora.\n");
    printf("\thelp:\t Mostrar esta ayuda.\n");
    printf("\tinput [file]:\t Abrir fichero como entrada\n");
    printf("funciones:\n");
    int i = 0;
    while(functionPointers[i] != NULL) {
        printf("\t%s\n", functionKeys[i]);
        i++;
    }
}

void loadFile(char* yytext) {
    char* inputString = strdup(yytext);
    while(*inputString != ' ') inputString++;
    inputString++;
    inputString[strlen(inputString) - 1] = 0;
    FILE* file = fopen(inputString, "r");
    if (file) {
        yyin = file;
        yypush_buffer_state(yy_create_buffer(yyin, YY_BUF_SIZE));
    } else {
        printf("Failed to open file: %s\n", inputString);
    }
}
