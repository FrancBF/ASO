#!/bin/bash

porcentaje=$(( $1 * 100 / $2 ))

if [ "$porcentaje" -lt 70 ]; then
    echo "OK"
elif [ "$porcentaje" -le 89 ]; then
    echo "AVISO"
else
    echo "CRÍTICO"
fi
