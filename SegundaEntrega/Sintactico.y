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

extern FILE* yyin;

void reiniciarPunteros();

FILE* archTS;
FILE *pArbol;
FILE *pIntermedia;

t_NodoArbol* Ptr;
t_NodoArbol* Sptr;
t_NodoArbol* Aptr;
t_NodoArbol* Eptr;
t_NodoArbol* Tptr;
t_NodoArbol* Optr;
t_NodoArbol* Fptr;
t_NodoArbol* Lptr;
t_NodoArbol* Wptr;
t_NodoArbol* Rptr;
t_NodoArbol* ILptr;
t_NodoArbol* RLptr;
t_NodoArbol* ASptr;
t_NodoArbol* IFptr;
t_NodoArbol* WHptr;
t_NodoArbol* ESTptr;
t_NodoArbol* SENptr;
t_NodoArbol* INIprt;
t_NodoArbol* LDECprt;
t_NodoArbol* VSprt;
t_NodoArbol* SGptr;
t_NodoArbol* LIDprt;
t_NodoArbol* TPprt;
t_NodoArbol* Vptr;
t_NodoArbol* CFptr;
t_NodoArbol* SFptr;
t_NodoArbol* SVptr;
t_NodoArbol* FDptr;
t_NodoArbol* FIptr;
t_NodoArbol* CONDprt;
t_NodoArbol* CONDFprt;
t_NodoArbol* AUXprt;


%}

%union{
	char* strVal; 
}

%token WHILE                 
%token IF 
%token ELSE                  
%token WRITE
%token READ                  
%token AND                   
%token OR
%token NOT
%token INIT
%token IGUALES
%token REPEAT               


%token FLOAT
%token STRING
%token INT

%token OP_MAS
%token OP_REST
%token OP_MULT
%token OP_DIV
%token OP_ASIG
%token COMP_DIST
%token COMP_MAY
%token COMP_MEN

%token COMP_IGUAL
%token COMP_MAYOI
%token COMP_MENOI

%token COND_AND
%token COND_OR
%token COND_NOT

%token P_A
%token P_C
%token LL_A
%token LL_C
%token C_A
%token C_C

%token COMA
%token PYC
%token DP

%token <strVal>ID
%token <strVal>CTE_INT
%token <strVal>CTE_FLOAT
%token <strVal>CTE_STRING

%token COMENT
%token whitespace
%token linefeed


%%



programaFinal:   programa                                                       {mostrarArbolDeIzqADer(&Ptr,pArbol);InOrden(&Ptr, pIntermedia);}
;

programa:   sentencia                                                           {Ptr = SENptr; printf(" FIN\n");}
;

sentencia:  sentencia declaracion                                               {SENptr = crearNodo("S",DECprt,SENptr);}
            |   sentencia estructura                                            {SENptr = crearNodo("S",ESTptr,SENptr);}
            |   estructura                                                      {SENptr = ESTptr;}
            |   declaracion                                                     {}
;

declaracion: INIT LL_A listaDeclaraciones LL_C                                   {INIprt = LDECprt;}
;

listaDeclaraciones: listaDeclaraciones listaID DP tipoDato                      {AUXprt = crearNodo(":",LIDprt,TPprt);LDECprt = crearNodo("LISTADEC",AUXprt,LDECprt);}
            |   listaID DP tipoDato                                             {LDECprt = crearNodo(":",LIDprt,TPprt);}
;

listaID:    listaID COMA ID                                                     {LIDprt = crearNodo(",",LIDprt,crearHoja($3));}
            |   ID                                                              {LIDprt = crearHoja($1);}
;

tipoDato:   STRING                                                              {TPprt = crearHoja("STRING");}
            |   INT                                                             {TPprt = crearHoja("INT");}
            |   FLOAT                                                           {TPprt = crearHoja("FLOAT");}
;

estructura: while                                                               {ESTptr = WHptr;}
            |   if                                                              {ESTptr = IFptr;}
            |   asign                                                           {ESTptr = ASptr;}
            |   write                                                           {ESTptr = Wptr;}
            |   repeat                                                          {ESTptr = RLptr;}
            |   read                                                            {ESTptr = Rptr;}
            |   iguales                                                         {ESTptr = ILptr;}
;

while:      WHILE condicionFinal LL_A sentencia LL_C                            {WHptr = crearNodo("WHILE", CONDFprt, SENptr);}
;

if:         IF condicionFinal LL_A sentenciaV LL_C                              {IFptr = crearNodo("IF", CONDFprt, SVptr);}
            | IF condicionFinal LL_A sentenciaV LL_C ELSE LL_A sentenciaF LL_C  {IFptr = crearNodo("IF", CONDFprt, crearNodo("CUERPO",SVptr,SFptr));}
;

sentenciaV: sentencia                                                           {SVptr = SENptr;}
;

sentenciaF: sentencia                                                           {SFptr = SENptr;}
;

condicionFinal: condicionFinal COND_AND condicion                               {CONDFprt = crearNodo("CondFIN",CONDFprt,CONDprt);}
            | P_A condicionFinal COND_AND condicion P_C                         {CONDFprt = crearNodo("CondFIN",CONDFprt,CONDprt);}
            /*| P_A condicionFinal COND_AND  condicionFinal P_C                 {printf("   ( condicionFinal && condicionFinal ) es CONDICIONFINAL\n");}*/
            | condicionFinal COND_OR condicion                                  {CONDFprt = crearNodo("CondFIN",CONDFprt,CONDprt);}
            | P_A condicionFinal COND_OR condicion P_C                          {CONDFprt = crearNodo("CondFIN",CONDFprt,CONDprt);}
            /*| P_A condicionFinal COND_OR  condicionFinal P_C                  {printf("   ( condicionFinal || condicionFinal ) es CONDICIONFINAL\n");}*/
            | COND_NOT condicionFinal                                           {;}
            | P_A COND_NOT condicion P_C                                        {CONDFprt = CONDprt;}
            | P_A condicion P_C                                                 {CONDFprt = CONDprt;}
            | condicion                                                         {CONDFprt = CONDprt;}
;

condicion:  factorDer COMP_MEN factorIzq                                        {CONDprt = crearNodo("<", FDptr,FIptr);}
            |   factorDer COMP_MAY factorIzq                                    {CONDprt = crearNodo(">", FDptr,FIptr);}
            |   factorDer COMP_MENOI factorIzq                                  {CONDprt = crearNodo("<=", FDptr,FIptr);}
            |   factorDer COMP_MAYOI factorIzq                                  {CONDprt = crearNodo(">=", FDptr,FIptr);}
            |   factorDer COMP_IGUAL factorIzq                                  {CONDprt = crearNodo("==", FDptr,FIptr);}
            |   factorDer COMP_DIST factorIzq                                   {CONDprt = crearNodo("!=", FDptr,FIptr);}
            |   COND_NOT factor                                                 {CONDprt = Fptr;}
            |   iguales                                                          {CONDprt = ILptr;}
;

factorDer: factor                                                               {FDptr = Fptr;}
;

factorIzq: factor                                                               {FIptr = Fptr;}
;

asign:      ID OP_ASIG expresion                                                {ASptr = crearNodo("=", Eptr, crearHoja($1));}
            | ID OP_ASIG CTE_STRING                                             {ASptr = crearNodo("=", crearHoja($1), crearHoja($3));}
;

iguales:     IGUALES P_A expresion COMA C_A listaExpresiones C_C P_C                      {ILptr = crearNodo("IGUALES", Eptr, Lptr);}
;

repeat:       REPEAT CTE_INT C_A sentencia C_C                  {RLptr = crearNodo("REPEAT", crearHoja($2), SENptr);}
;

signo:      OP_MAS                                                              {SGptr = crearHoja("+");}
            | OP_REST                                                           {SGptr = crearHoja("-");}
            | OP_MULT                                                           {SGptr = crearHoja("*");}
            | OP_DIV                                                            {SGptr = crearHoja("/");}
;

valores:    valores PYC valor                                                   {VSprt = crearNodo(";",VSprt,Vptr);}
            | valor                                                             {VSprt = Vptr;}
;

valor:      CTE_INT                                                             {Vptr = crearHoja($1);}
            | OP_REST CTE_INT                                                   {Vptr = crearHoja($2);}
            | CTE_FLOAT                                                         {Vptr = crearHoja($1);}
            | OP_REST CTE_FLOAT                                                 {Vptr = crearHoja($2);}
            | ID                                                                {Vptr = crearHoja($1);}
;

listaExpresiones:  listaExpresiones PYC expresion                               {Lptr = crearNodo(";",Lptr,Eptr);}
            | expresion                                                         {Lptr = Eptr;}
;

expresion:  expresion OP_MAS termino                                            {Eptr = crearNodo("+",Eptr,Tptr);}
            | expresion OP_REST termino                                         {Eptr = crearNodo("-",Eptr,Tptr);}
            | termino                                                           {Eptr = Tptr;}
;

termino:    termino OP_DIV operando                                             {Tptr = crearNodo("/",Tptr,Optr);}
            |termino OP_MULT operando                                           {Tptr = crearNodo("*",Tptr,Optr);}
            | operando                                                          {Tptr = Optr;}
;

operando:   CTE_INT                                                             {Optr = crearHoja($1);}
            | OP_REST CTE_INT                                                   {Optr = crearHoja($2);}
            | CTE_FLOAT                                                         {Optr = crearHoja($1);}
            | OP_REST CTE_FLOAT                                                 {Optr = crearHoja($2);}
            | ID                                                                {Optr = crearHoja($1);}
            | P_A expresion P_C                                                 {Optr = Eptr;}
;

write:      WRITE factor                                                        {Wptr = crearNodo("W",crearHoja("WRITE"),Fptr);}
;

read:       READ ID                                                             {Rptr = crearNodo("R",crearHoja("READ"),crearHoja($2));}
;

factor:     ID                                                                  {Fptr = crearHoja($1);}
            | CTE_INT                                                           {Fptr = crearHoja($1);}
            | OP_REST CTE_INT                                                   {Fptr = crearHoja($2);}
            | CTE_STRING                                                        {Fptr = crearHoja($1);}
            | CTE_FLOAT                                                         {Fptr = crearHoja($1);}
            | OP_REST CTE_FLOAT                                                 {Fptr = crearHoja($2);}
;  

%%


int main(int argc, char* argv[])
{
    archTS = fopen("ts.txt","w");
    if((pIntermedia = fopen("Intermedia.txt", "wt")) == NULL)
	{
        printf("\nNo se puede abrir el archivo %s\n", "Intermedia.txt");
    }

    if((yyin = fopen(argv[1],"rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo %s\n", argv[1]);
    }

    yyparse();

    generarArchivo();
    printf("\nCOMPILACION EXITOSA!\n");
    reiniciarPunteros();
    fclose(pIntermedia);
    fclose(yyin);
    
    return 0;
}

void reiniciarPunteros(){
Ptr = NULL;
Sptr = NULL;
Aptr = NULL;
Eptr = NULL;
Tptr = NULL;
Optr = NULL;
Fptr = NULL;
Lptr = NULL;
Wptr = NULL;
Rptr = NULL;
ILptr = NULL;
ASptr = NULL;
IFptr = NULL;
WHptr = NULL;
ESTptr = NULL;
SENptr = NULL;
INIprt = NULL;
LDECprt = NULL;
VSprt = NULL;
SGptr = NULL;
LIDprt = NULL;
TPprt = NULL;
Vptr = NULL;
CFptr = NULL;
SFptr = NULL;
SVptr = NULL;
FDptr = NULL;
FIptr = NULL;
CONDprt = NULL;
CONDFprt = NULL;
AUXprt = NULL;
RLptr = NULL;
																						
}
