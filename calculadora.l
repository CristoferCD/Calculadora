%{
	#include <stdlib.h>
	#include "calculadora.tab.h"
	#include "../tablaSimbolos.h"

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

"q"|"Q"			{ return QUIT; }
{imaginary_lit}		/* not implemented */
{float_lit}		{ yylval.numValue = atof(yytext); printf("[float]Getting llval %lf and text %s\n", yylval.numValue, yytext); return NUMBER; }
{int_lit}		{ yylval.numValue = atoi(yytext); printf("[int]Getting llval %d and text %s\n", yylval.numValue, yytext); return NUMBER; }
{identifier}	{ return ts_get(&yylval, yytext); }
"\n"			{ return LINEBREAK; }
.				{ return *yytext; }

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
		newNode->key = yytext;
		newNode->id = ID;
		symbolTable_insert(newNode);
		return ID;
	}	
}
