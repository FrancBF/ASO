#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 FICHERO"
    exit 1
fi

# Comprobacion argumentos.
# Si cuento argmumentos y igual a 0, entonces "uso el nombre del fichero  + Fichero, salir con error. Fin


if [[ ! -f "$1" ]]; then
    echo "Error: el fichero $1 no existe"
    exit 1
fi

# Comprobacion si exite el archivo
# Si no existe (!) el archivo (-f) dado ($1), entonces error..., salir con error. Fin

sed 's/@\(gmail.com\|hotmail.com\)$/@alu.edu.gva.es/' "$1"

# s significa substitute (sustituir).
# El primer texto es lo que queremos encontrar.(@ + gmail.com o (|) hotmail.com...)
# El segundo texto es aquello por lo que queremos sustituirlo. 
# Es decir sed s/texto_a_buscar/texto_a_remplazar/ archivo

# la @ la buscara literalmente
# Los parentesis \(...\) sirven para agrupar varias opciones, en sed tienen que \ invertidas
# $ Indica el final de la línea.

# sed	Procesa texto
# s	Sustituir
# @	Busca la arroba
# \( y \)	Agrupan alternativas
# \|	Significa «o»
# $	Final de línea
# @alu.edu.gva.es	Texto de sustitución
# $1	Archivo recibido como argumento
