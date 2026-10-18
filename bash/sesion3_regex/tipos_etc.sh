#!/bin/bash

configuracion=0
copias=0

re_conf='\.conf$'
re_copias='(.\bak|~)$'


for fichero in /etc/*
do
    if [[ -f "$fichero" ]]; then
        nombre=${fichero##*/}

        if [[ $nombre =~ $re_conf ]]; then
             echo "  $fichero"
             ((configuracion++))
        fi

        if [[ $nombre =~ $re_copias ]]; then
             ((copias++))
        fi
    fi
done

echo "Configuración:  $configuracion"
echo "Copias de seguridad:  $copias"
