#!/bin/bash

shell_buscar="/bin/bash"

if [[ $# -gt 1 ]]; then
    echo "Error: demasiados parámetros"
    exit 1
fi

# Comprobamos que si el numero de argumentos es mayor a 1, entonces echo Error y salida Erro

if [[ $# -eq 1 ]]; then
    if [[ ! $1 =~ ^/([a-z]+/)*[a-z]+$ ]]; then
        echo "Error: $1 no es una ruta válida"
        exit 1
    fi

    shell_buscar="$1"
fi

total=0
usuarios_normales=0

# Comprobamos que de argumentos es igual  a 1, entonces negamos la expresión !, del argumento que recibe
# el script y comprueba si conincide =~ que se una expresion regualar que empiece con una barra y minuscula

# Elemento	Significado
#     ^         Inicio del texto
#     /         La ruta comienza por una barra
#  [a-z]+       Una o más letras minúsculas
#  (...)        Agrupa una parte de la expresión
#    *          Repite el grupo cero o más veces
#    $          Final del texto


while IFS=':' read -r usuario x uid gid descripcion home shell; do

    if [[ "$shell" == "$shell_buscar" ]]; then
        echo "$usuario:$uid:$home:$shell"

        ((total++))

        if [[ $uid -ge 1000 ]]; then
            ((usuarios_normales++))
        fi
    fi

done < /etc/passwd

echo ""
echo "Cuentas listadas: $total"
echo "Con UID >= 1000: $usuarios_normales"

# IFS=':' IFS es el separador de campos de Bash.
# Con esto le  decimos que utilice los dos puntos (:) para separar los campos de cada línea

# read -r
# Lee una línea y distribuye sus campos entre las variables indicadas, en este caso usuario, x, uid...
# Así, el tercer campo se guarda en uid, el sexto en home y el séptimo en shell.

# [[ "$shell" == "$shell_buscar" ]] Compara la shell de cada usuario con la que queremos buscar.

# ((total++)) Incrementa el contador en una unidad.

# done < /etc/passwd Indica que el bucle debe leer las líneas del archivo /etc/passwd.
