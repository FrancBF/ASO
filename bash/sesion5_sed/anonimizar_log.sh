
#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 FICHERO"
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "Error: el fichero $1 no existe"
    exit 1
fi

# Comprobacion argumentos
# Comprobacion si el archivo exite

sed 's/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/X.X.X.X/g' "$1" > "$1.anonimo"

echo "Fichero anonimizado: $1.anonimo"

# Sustituir direcciones IP
# [0-9]	                             Un número del 0 al 9
# [0-9]\{1,3\}                       Entre uno y tres dígitos.
# \.                                 Un punto literal.
# \(...\)\{3\}                       Repite tres veces el grupo formado por un punto y entre uno y tres dígitos.
# Por tanto, reconoce cuatro grupos numéricos separados por puntos.

# /X.X.X.X/g
# La g significa global.
# Hace que sed sustituya todas las coincidencias de una línea, no solamente la primera.

# > dirige la salida de un archivo, por lo tanto lo guarda en este caso con el nombre del argumento.anonimo
