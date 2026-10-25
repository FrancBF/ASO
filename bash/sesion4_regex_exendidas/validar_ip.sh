#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 DIRECCION_IP"
    exit 1
fi

re='^[0-9]{1,3}(\.[0-9]{1,3}){3}$'  #[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ sería lo mismo.

if [[ $1 =~ $re ]]; then
    echo "$1 tiene formato de IP"
else
    echo "$1 no tiene formato de IP"
fi

# Esta expresión comprueba el formato, no que cada octeto esté entre 0 y 255.
# Por eso 999.999.999.999 cumple el formato, pero no es una IPv4 válida.
