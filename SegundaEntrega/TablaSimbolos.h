#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAM_MATRIZ 2000

typedef struct sRegistro
{
    char nombre[50];
    char tipo[50];
    char valor[50];
    int  longitud;
}tRegistro;

tRegistro matrizDeRegistros[TAM_MATRIZ];

int ultimaPosicion = 0;

int validarValorTabla (char* );
void insertarIDEnTablaDeSimbolos(char* );
void generarArchivo();
void insertarFLOATEnTablaDeSimbolos(char* );
char* eliminarComillasCTESTRING(char* );

int validarValorTabla (char* id){
    int aux=0;
    while( ultimaPosicion > aux ){
        if(strcmp(id,matrizDeRegistros[aux].nombre) == 0){
            return aux;
        }
        aux++;
    }
    return -1;
}

char* eliminarComillasCTESTRING(char* str)
{
    char* cad = str;
    char* cadInicio = cad;
    while(*str)
    {
        if(*str != '"')
        {
            (*cad) = (*str);
            cad++;
        }
        str++;
    }
    *cad = '\0';
    return cadInicio;
}

void insertarIDEnTablaDeSimbolos(char* id)
{  
    if(validarValorTabla(id) == -1){
        strcpy(matrizDeRegistros[ultimaPosicion].nombre,id);
        ultimaPosicion++;
    }
}

void insertarEnTablaDeSimbolos(char* id)
{  
    char nombre[100] = "_";
    strcat(nombre,id);
    if(validarValorTabla(nombre) == -1){
        strcpy(matrizDeRegistros[ultimaPosicion].valor,id);
        strcpy(matrizDeRegistros[ultimaPosicion].nombre,nombre);
        ultimaPosicion++;
    }
}

void generarArchivo()
{
  FILE *fp;
  
  fp = fopen ( "ts.txt", "w+" );
  
  fprintf(fp,"              NOMBRE             |        TIPO        |              VALOR              |  LONGITUD   |\n");
  fprintf(fp,"------------------------------------------------------------------------------------------------------|\n");

  int i;
  for(i = 0; i < ultimaPosicion ; i++)
  {
    fprintf(fp, " %-*s | %-*s | %*s | %*s |\n", 31, matrizDeRegistros[i].nombre,
                                                 18, "",
                                                 31, matrizDeRegistros[i].valor,
                                                 11, "");
  }
  fclose ( fp );
}