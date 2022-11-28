%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <math.h>
#include <limits.h>
#include "y.tab.h"
#include "TablaSimbolos.h"
#include "Arbol.h"

void yyerror(char* mensaje);
void informarError(char* mensaje);
void tokenInvalido(void);

#define MAX_VALUE_FLOAT INT_MAX

%}

%option noyywrap
%option yylineno


whitespace              [ \t\r\v\f]
linefeed                [\n]
DIGITO			[0-9]
LETRA			[a-zA-Z]
CTE_INT                 ({DIGITO}+)
ID			{LETRA}({LETRA}|{DIGITO}|_)*
CTE_FLOAT               {DIGITO}+"."{DIGITO}+
CTE_STRING	        \"([^\"\\\\]|\\\\.)*\"
COMENTARIO_ABRE		"/*"
COMENTARIO_CIERRA	"*/"
COMENT			{COMENTARIO_ABRE}([^-/])*?{COMENTARIO_CIERRA}


OP_MAS                  "+"
OP_REST                 "-"
OP_MULT                 "*"
OP_DIV                  "/"
OP_ASIG			        ":="

COMILLA_D		        ["]
COMILLA_A		        [“]
COMILLA_C		        [”]

COMP_DIST				"!="
COMP_MAY				">"
COMP_MEN	            "<"
COMP_IGUAL				"=="
COMP_MAYOI				">="
COMP_MENOI				"<="

COND_AND                "&&"
COND_OR                 "||"
COND_NOT                "!"

P_A                     "("
P_C                     ")"
LL_A                    "{"
LL_C                    "}"
C_A                     "["
C_C                     "]"

COMA                    ","
PYC                     ";"
DP                      ":"

%%

"WHILE"                 {return WHILE;}
"IF"                    {return IF;}
"ELSE"                  {return ELSE;}
"WRITE"                 {return WRITE;}
"READ"                  {return READ;}
"AND"                   {return AND;}
"OR"                    {return OR;}
"NOT"                   {return NOT;}
"INIT"                	{return INIT;}
"STRING"                {return STRING;}
"INT"                   {return INT;}
"FLOAT"                 {return FLOAT;}
"IGUALES"               {return IGUALES;}
"REPEAT"                {return REPEAT;}

{OP_MAS}                {return OP_MAS;}
{OP_REST}               {return OP_REST;}
{OP_MULT}               {return OP_MULT;}
{OP_DIV}                {return OP_DIV;}
{OP_ASIG}		{return OP_ASIG;}

{COMP_DIST}		{return COMP_DIST;}
{COMP_MAY}		{return COMP_MAY;}
{COMP_MEN}	        {return COMP_MEN;}
{COMP_IGUAL}		{return COMP_IGUAL;}
{COMP_MAYOI}		{return COMP_MAYOI;}
{COMP_MENOI}		{return COMP_MENOI;}

{COND_AND}              {return COND_AND;}
{COND_OR}               {return COND_OR;}
{COND_NOT}              {return COND_NOT;}

{P_A}                   {return P_A;}
{P_C}                   {return P_C;}
{LL_A}                  {return LL_A;}
{LL_C}                  {return LL_C;}
{C_A}                   {return C_A;}
{C_C}                   {return C_C;}

{COMA}                  {return COMA;}
{PYC}                   {return PYC;}
{DP}                    {return DP;}

{ID}					{
                        if(strlen(yytext) > 20)
                            {
                                informarError("El ID supera el tam maximo (VALOR MAXIMO: 20)"); 
                            }
                        else {                            
                            insertarIDEnTablaDeSimbolos(yytext);
                            yylval.strVal = strdup(yytext);
                            return ID;
                            }
                        }

{CTE_FLOAT}				{
                        float num = atof(strdup(yytext));
                        if( num > FLT_MAX || FLT_MIN > num )
                        {
                            yyerror("FLOAT demasiado largo ");
                        }
                        else
                        {
                            insertarEnTablaDeSimbolos(yytext);
                            yylval.strVal = strdup(yytext);
                            return CTE_FLOAT;	        
                        }
                        }

{CTE_INT}               {                        
                        int num = atoi(strdup(yytext));
                        if(num > 32767) // máximo valor de un numero de 16 bits con signo
                        {
                            yyerror("INT demasiado largo - (VALOR MAXIMO: 32767)");
                        }
                        else
                        {
                            insertarEnTablaDeSimbolos(yytext);
                            yylval.strVal = strdup(yytext);
                            return CTE_INT;	
                        }
}


{COMENT}                {;}

{CTE_STRING}		{
                    if(strlen(yytext) > 30)
                        {
                         informarError("La constante STRING supera el tam maximo (VALOR MAXIMO: 30)"); 
                        }
                    else{
                        insertarEnTablaDeSimbolos(eliminarComillasCTESTRING(yytext));
                        yylval.strVal = strdup(yytext);
                        return CTE_STRING;
                    }
                    }

{linefeed}			{;} 
{whitespace}		{;}
" "
.					{tokenInvalido();}

%%


void informarError(char* mensajeError)
{
    printf("ERROR - %s - EN LA LINEA %d\n", mensajeError, yylineno);
    system("Pause");
    exit(1);
}

void yyerror(char* mensajeError)
{
    printf("ERROR - %s - EN LA LINEA %d\n", mensajeError, yylineno); 
    system("Pause");
    exit(1);
}

void tokenInvalido(void){
	printf("ERROR - \"%s\" TOKEN INVALIDO EN LA LINEA %d\n", yytext, yylineno);
	system("Pause");
	exit(1);
}
