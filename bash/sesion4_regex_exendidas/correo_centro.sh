#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 CORREO"
    exit 1
fi

re='^[a-z0-9._-]+@(edu\.gva\.es|alu\.edu\.gva\.es)$'

if [[ $1 =~ $re ]]; then
    if [[ $1 =~ @edu\.gva\.es$ ]]; then
        echo "$1: correo del profesorado"
    else
        echo "$1: correo del alumnado"
    fi
else
    echo "$1: correo no válido"
fi



# ^ Indica el comienzo del texto.
# [a-z0-9._-] Permite letras minúsculas, números, puntos, guiones y guiones bajos. 
# + El + exige uno o más caracteres.
# @ Exige el símbolo de la arroba.
# (edu\.gva\.es|alu\.edu\.gva\.es) Acepta uno de los dos dominios. El símbolo | significa «o» y los paréntesis agrupan las alternativas. La barra invertida \ hace que cada punto sea un punto literal)
# $ Indica el final del texto.