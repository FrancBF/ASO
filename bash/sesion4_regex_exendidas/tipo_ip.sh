#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 DIRECCION_IP"
    exit 1
fi

ip="$1"

if [[ $ip =~ ^127\. ]]; then
    echo "$ip: dirección LOOPBACK"   # Dirección LOOBBACK
elif [[ $ip =~ ^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[01])\. ]]; then
    echo "$ip: dirección PRIVADA"    # Dirección PRIVADA
else
    echo "$ip: dirección PUBLICA"    # Dirección PÚBLICA
fi

# DIRECCION LOOBPACK 127.
# La expresión ^127\. significa que la dirección debe comenzar por 127, por ejemplo 127.0.0.0.1
# ^: principio del texto.
# 127: esos tres números.
# \.: un punto literal.

# Direcciones PRIVADADS
# Tres rangos privados que pide la práctica:
# ^10\.: direcciones que comienzan por 10..
# ^192\.168\.: direcciones que comienzan por 192.168..
# ^172\.(1[6-9]|2[0-9]|3[01])\.: direcciones cuyo segundo octeto está entre 16 y 31.
# (1[6-9]|2[0-9]|3[01])
#  1[6-9]: números del 16 al 19.
#  2[0-9]: números del 20 al 29.
#  3[01]: números 30 y 31.
#  |: significa «o».