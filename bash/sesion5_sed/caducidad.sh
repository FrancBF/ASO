#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 NUMERO_DIAS"
    exit 1
fi

# Comprobacion de introduccion de argumento, en este caso dias que vamos a modificar

if [[ ! $1 =~ ^[0-9]{1,3}$ ]]; then
    echo "Error: $1 no es un número de días válido"
    exit 1
fi

# Validamos que el argumento intreoducido tenga cualquier número del 0 al 9 y tenga entre 1 y 3 cifras

if [[ ! -f login.defs ]]; then
    echo "Error: no existe el fichero login.defs"
    exit 1
fi

# Comprobamos que exite el archivo

anterior=$(grep -E '^[[:space:]]*PASS_MAX_DAYS' login.defs | awk '{print $2}')

# grep: busca la línea que contiene PASS_MAX_DAYS.
# awk '{print $2}: extrae el segundo campo, que es el número de días.
# $(...): ejecuta el comando y guarda su resultado en una variable.


sed -i.bak -E "s/^([[:space:]]*PASS_MAX_DAYS[[:space:]]+)[0-9]+/\1$1/" login.defs

# sed   Cambia 
# -i	Modifica directamente el archivo
# .bak	Crea una copia de seguridad llamada login.defs.bak
# -E	Activa las expresiones regulares extendidas
# s	Sustituye texto
# \1	Recupera el contenido del primer grupo capturado
# $1	Introduce el nuevo número de días.

echo "Antes:   PASS_MAX_DAYS $anterior"
echo "Después: PASS_MAX_DAYS $1"
