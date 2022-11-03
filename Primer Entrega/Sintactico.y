%{
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
int yylex();
int yyparse();
int yyerror();
%}

%start programa 
%right OP_ASIG 
%left OP_SUMA OP_RESTA
%left OP_MULT OP_DIV
%right MENOS_UNARIO

%token OP_MAY OP_MAYIGU OP_MEN OP_MENIGU OP_IGUAL OP_DIF
%token WHILE IF INTEGER FLOAT STRING ELSE THEN INIT IN AND OR NOT LONG IGUALES REPEAT
%token WRITE COMA ENDIF ENDWHILE DO READ PAR_A PAR_C COR_A COR_C LLA_A LLA_C PYC DP

%token ID CTE_INTEGER CTE_FLOAT CTE_STRING


%%
programa:
    declaracion bloque          {printf("\nREGLA 1: <programa> --> <declaracion> <bloque>\n");} 

bloque:
    sentencia                       {printf("\nREGLA 2: <bloque> --> <sentencia>\n");}       
    | bloque sentencia            {printf("\nREGLA 3: <bloque> --> <bloque> <sentencia>\n");};              

sentencia:
     asignacion                      {printf("\nREGLA 4: <sentencia> --> <asignacion>\n");}   
    |ciclo                           {printf("\nREGLA 5: <sentencia> --> <ciclo>\n");}   
    |seleccion                       {printf("\nREGLA 6: <sentencia> --> <seleccion>\n");}   
    |salida                          {printf("\nREGLA 7: <sentencia> --> <salida>\n");}   
    |entrada                         {printf("\nREGLA 8: <sentencia> --> <entrada>\n");}
    |repeat                          {printf("\nREGLA 9: <sentencia> --> <repeat>\n");}
    | iguales                        {printf("\nREGLA 30: <sentencia> --> <iguales>\n");};

declaracion:
    INIT LLA_A listaDeclaraciones  LLA_C    {printf("\nREGLA 10: <declaracion> --> INIT LLA_A <listaDeclaraciones> LLA_C\n");};    

listaDeclaraciones:
    listavar DP tipodato    {printf("\nREGLA 11: <listaDeclaraciones> --> <listavar> DP <tipodato> \n");}   
    |listaDeclaraciones listavar DP tipodato    {printf("\nREGLA 12: <listaDeclaraciones> --> <listaDeclaraciones> <listavar> DP <tipodato> \n");};    

listavar:
    ID                              {printf("\nREGLA 13: <listavar> --> ID \n");}
    | listavar COMA ID              {printf("\nREGLA 14: <listavar> --> <listavar> COMA ID\n");};

tipodato:
    INTEGER                         {printf("\nREGLA 15: <tipodato> --> INTEGER  \n");}
    | FLOAT                         {printf("\nREGLA 16: <tipodato> --> FLOAT \n");}
    | STRING                        {printf("\nREGLA 17: <tipodato> --> STRING \n");};

seleccion:
    IF condicion THEN bloque ELSE bloque ENDIF      {printf("\nREGLA 18: <seleccion> --> IF <condicion> THEN <bloque> ELSE <bloque> ENDIF\n");}
    | IF condicion THEN bloque ENDIF                  {printf("\nREGLA 19: <seleccion> --> IF <condicion> THEN <bloque> ENDIF \n");};

ciclo:
    WHILE ID IN COR_A lista COR_C DO bloque ENDWHILE         {printf("\nREGLA 20: <ciclo> --> WHILE ID IN COR_A <lista> COR_C DO <sentencia> ENDWHILE\n");};

entrada:
    READ ID                                          {printf("\nREGLA 21: <entrada> --> READ ID\n");};

salida:
    WRITE CTE_STRING                                   {printf("\nREGLA 22: <salida> -->  WRITE CTE_STRING  \n");};

asignacion:
    ID OP_ASIG expresion                                {printf("\nREGLA 23: <asignacion> --> ID OP_ASIG <expresion> \n");}
    | ID OP_ASIG CTE_STRING                 		{printf("\nREGLA 24: <asignacion> --> ID OP_ASIG CTE_STRING \n");};

condicion:
    comparacion                                         {printf("\nREGLA 25: <condicion> --> <comparacion> \n");}
    | condicion AND comparacion                         {printf("\nREGLA 26: <condicion> --> <comparacion> AND <comparacion>\n");}
    | condicion OR comparacion                          {printf("\nREGLA 27: <condicion> --> <comparacion> OR <comparacion>\n");}
    | PAR_A NOT condicion PAR_C AND comparacion         {printf("\nREGLA 28: <condicion> --> PAR_A NOT <condicion> PAR_C <comparacion> \n");}
    | PAR_A  NOT condicion PAR_C OR comparacion         {printf("\nREGLA 29: <condicion> --> PAR_A NOT <condicion> PAR_C <comparacion> \n");};

comparacion:
    expresion comparador expresion                     {printf("\nREGLA 31: <comparacion> --> <expresion><comparador><expresion> \n");};

expresion:
    expresion OP_SUMA termino                           {printf("\nREGLA 32: <expresion> --> <expresion><OP_SUMA><termino> \n");}
    | expresion OP_RESTA termino                        {printf("\nREGLA 33: <expresion> --> <expresion><OP_RESTA><termino> \n");}
    | termino                                           {printf("\nREGLA 34: <expresion> --> <termino> \n");}
    |OP_RESTA expresion %prec MENOS_UNARIO              {printf("\nREGLA 35: <expresion> --> OP_RESTA <expresion> \n");}                               ;

termino:
    termino OP_MULT factor                              {printf("\nREGLA 36: <termino> --> <termino> OP_MULT <factor> \n");}
    | termino OP_DIV factor                             {printf("\nREGLA 37: <termino> --> <termino> OP_DIV <factor> \n");}
    | factor                                            {printf("\nREGLA 38: <termino> --> <factor> \n");};

lista:
    factor                                              {printf("\nREGLA 39: <lista> --> <factor> \n");}
    | lista COMA factor                                 {printf("\nREGLA 40: <lista> --> <lista> COMA <factor> \n");};

factor:
    PAR_A expresion PAR_C       {printf("\nREGLA 41: <factor> --> PAR_A<expresion><PAR_C>\n");} 
    | CTE_FLOAT                {printf("\nREGLA 42: <factor> --> CTE_FLOAT\n");} 
    | ID                        {printf("\nREGLA 43: <factor> --> ID\n");} 
    | CTE_INTEGER                 {printf("\nREGLA 44: <factor> --> <CTE_INTEGER>\n");};

comparador:
    OP_MAY          {printf("\nREGLA 45: <comparador> --> <OP_MAY>\n");} 
    | OP_MEN        {printf("\nREGLA 46: <comparador> --> <OP_MEN>\n");} 
    | OP_MENIGU     {printf("\nREGLA 47: <bloque> --> <OP_MENIGU>\n");} 
    | OP_MAYIGU     {printf("\nREGLA 48: <bloque> --> <OP_MAYIGU>\n");} 
    | OP_IGUAL      {printf("\nREGLA 49: <bloque> --> <OP_IGUAL>\n");} 
    | OP_DIF        {printf("\nREGLA 50: <bloque> --> <OP_DIF>\n");};

lista_expr:
    expresion                                              {printf("\nREGLA 51: <lista_expr> --> <expresion> \n");}
    | lista_expr PYC expresion                             {printf("\nREGLA 52: <lista_expr> --> <lista_expr><PYC><expresion> \n");};

iguales:
    IGUALES PAR_A expresion COMA COR_A lista_expr COR_C PAR_C	{printf("\nREGLA 53: <iguales> --> <IGUALES><PAR_A><expresion><COMA><COR_A><lisa_expr><COR_C><PAR_C>\n");}; 
   
repeat:
    REPEAT CTE_INTEGER COR_A sentencia COR_C {printf("\nREGLA 54: <repeat> --> <REPEAT><COR_A><bloque><COR_C>\n");}; 


%%
