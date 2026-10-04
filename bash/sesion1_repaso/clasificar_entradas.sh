#!/bin/bash

for entrada in ~/prueba_bash/*; do
    nombre=$(basename "$entrada")


    if [ -f "$entrada" ]; then
        echo "$nombre fichero"
    elif [ -d "$entrada" ]; then
        echo "$nombre directorio"
    fi

done
