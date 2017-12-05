%{
	#include <math.h>
	#include "../calculadora.h"
	#include "../tablaSimbolos.h"
%}

%union {
	double numValue;
	itemNode* symNode;
}

%token <numValue> NUMBER
%token <symNode> ID FUNC
%token LINEBREAK
%token QUIT

%type <numValue> exp

%left '-' '+'
%left '*' '/'
%right '^'
%right '(' ')'

%%
input:	/* empty */
	| input line
	| QUIT	{ printf ("Saliendo...\n"); exit(0); }
;

line:	LINEBREAK
	| exp LINEBREAK { printf (">>  %g\n", $1); }
;

exp:	NUMBER				{ $$ = $1; }
	|	ID					{ $$ = $1->numValue; }
	|	ID '=' exp			{ $$ = $3; $1->numValue = $3; }
	|	FUNC '(' exp ')' 	{ $$ = (*((*$1).function))($3); }
	| exp '+' exp			{ $$ = $1 + $3; printf("parsing sum %f+%f\n",$1, $3);}
	| exp '-' exp			{ $$ = $1 - $3; }
	| exp '*' exp			{ $$ = $1 * $3; }
	| exp '/' exp			{ $$ = $1 / $3; }
	| exp '^' exp			{ $$ = pow($1, $3); }
	| '(' exp ')'			{ $$ = $2; }
;
%%

int yyerror(char *s) {
	printf("yyerror : %s\n",s);
}
