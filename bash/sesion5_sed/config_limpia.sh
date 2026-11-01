#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 FICHERO"
    exit 1
fi

# Si cuento argmumentos y igual a 0, entonces "uso el nombre del fichero  + Fichero, salir con error. Fin

if [[ ! -f "$1" ]]; then
    echo "Error: el fichero $1 no existe"
    exit 1
fi

# Si no existe (!) el archivo (-f) dado ($1), entonces error..., salir con error. Fin

sed '/^#/d; /^$/d' "$1"

# sed	Ejecuta el editor de flujo
# /^#/d	Elimina las líneas que comienzan por #
# ;	Separa dos instrucciones de sed
# /^$/d	Elimina las líneas vacías
# $1	Indica el archivo que vamos a procesar

# Solo muestra el archivo en pantall, no modifica el arichivo.
