#!/bin/bash

fichero=${1:-/etc/login.defs}

if [[ ! -f "$fichero" ]]; then
    echo "Error: el fichero no existe."
    exit 1
fi

total=0
utiles=0
re_comentario='^[[:space:]]*#'
re_vacia='^[[:space:]]*$'


while read -r linea
do
   ((total++))

   if [[ $linea =~ $re_comentario || $linea =~ $re_vacia ]]; then
       continue
   fi

   echo "$linea"
   ((utiles++))
done < "$fichero"

echo "Líneas totales:  $total"
echo "Líneas útiles:  $utiles"


# Despues de ejecutar el comando grep '^PASS_MAX_DAYS' /etc/login.defs en mi ubuntu aparece 99999
# Esto indica que la contraseña puede utulizarse durante un periodo infinito o de 99999
# Esta claro que no es una configuración segura, ya que deberia de existir una política de contraseñas
# adecuada al rieso y necesidad de cadad sistema, en este caso este sistema es solo de prueba y 
# no pasa nada. 
