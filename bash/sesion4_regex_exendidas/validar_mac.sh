#!/bin/bash

re='^[0-9a-fA-F]{2}([:-][0-9a-fA-F]{2}){5}$'

if [[ $1 =~ $re ]]; then
    echo "$1 es una MAC válida"
else
    echo "$1 no es una MAC válida"
fi


#   Fragmento	     Significado
#      ^             Inicio del texto.
# [0-9a-fA-F]{2}     Primer par de caracteres hexadecimales.
#      [:-]          Un separador: : o -.
# [0-9a-fA-F]{2}     Otro par hexadecimal.
#    (...){5}        Repite 5 veces el separador y el par.
#       $            Final del texto.