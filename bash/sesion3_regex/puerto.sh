#/!bin/bash

if [[ $# -eq 0 ]]; then
     echo "uso:  $0 NUMERO_PUERTO"
     exit 1
fi


re='^[0-9]+$'

if [[ $1 =~ $re ]]; then
    echo "$1 es un número"
else
    echo "$1 no es un número"
    exit 1
fi

if (( $1 >= 1 && $1 <= 65535 )); then
    echo "$1 es un puerto válido"
else
    echo "$1 está fuera de rango (1-65535)"
fi
