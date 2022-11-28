#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct s_NodoArbol
{
    struct s_NodoArbol *izq;
    struct s_NodoArbol *der;
    char info[50];
}t_NodoArbol;

typedef t_NodoArbol* t_arbol;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

t_NodoArbol* crearHoja( char* lexema);
t_NodoArbol* crearNodo(char* lexema, t_NodoArbol* hijoIzq, t_NodoArbol* hijoDer);
void VaciarArbol(t_arbol *pa);
void InOrden(t_arbol *pa, FILE *pIntermedia);
void mostrarArbolDeIzqADer(t_arbol *pa, FILE* pArbol);
void mostrarArbolDeIzqADerAux(t_arbol *pa,int nivel, FILE* pArbol);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

t_NodoArbol* crearHoja( char* lexema)
{
    t_NodoArbol* nue = (t_NodoArbol*) malloc (sizeof(t_NodoArbol));
    if(!nue)
    {
        printf("No se pudo reservar memoria para el nodo.\n");
        return NULL;
    }
    nue->izq = NULL;
    nue->der = NULL;
    strcpy(nue->info, lexema);
    return nue;
}

t_NodoArbol* crearNodo(char* lexema, t_NodoArbol* hijoIzq, t_NodoArbol* hijoDer)
{
    t_NodoArbol* padre = (t_NodoArbol*) malloc (sizeof(t_NodoArbol));
    
    if(!padre)
    {
        printf("No se pudo reservar memoria para el nodo.\n");
        return NULL;
    }

    padre->izq = hijoIzq;
    padre->der = hijoDer;
    strcpy(padre->info, lexema);

    return padre;
}

void VaciarArbol(t_arbol *pa)
{
    if(!*pa)
        return;
    VaciarArbol(&(*pa)->izq);
    VaciarArbol(&(*pa)->der);
    free(*pa);
    *pa = NULL;
}

void InOrden(t_arbol *pa, FILE *pIntermedia)
{
    if(!(*pa))
        return;
    InOrden(&(*pa)->izq, pIntermedia);
    fprintf(pIntermedia, " %s  ", (*pa)->info);  
    InOrden(&(*pa)->der, pIntermedia);
}

void mostrarArbolDeIzqADer(t_arbol *pa, FILE* pArbol)
{
    pArbol=fopen("Arbol.txt","wt");
    mostrarArbolDeIzqADerAux(pa,0,pArbol);
    fclose(pArbol);
}
void mostrarArbolDeIzqADerAux(t_arbol *pa,int nivel, FILE* pArbol)
{
    int i;
    if(!*pa)
        return;
    mostrarArbolDeIzqADerAux(&(*pa)->der,nivel+1,pArbol);
    fprintf(pArbol,"\n");
    for(i = 0; i < nivel; i++)
        fprintf(pArbol,"\t");
    fprintf(pArbol,"%s", (*pa)->info);
    mostrarArbolDeIzqADerAux(&(*pa)->izq,nivel+1,pArbol);
}