#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 CONTRASEÑA"
    exit 1
fi

password="$1"
segura=1


#"$1" recoge la contraseña que escribimos al ejecutar el script.
# password="$1" la guarda en una variable para utilizarla en las siguientes comprobaciones.
# Si no introducimos ningún argumento, mostramos el uso correcto y terminamos.

# 1. Comprobar longitud mínima de 12 caracteres

if [[ $password =~ .{12,} ]]; then
    echo "OK: Tiene al menos 12 caracteres"
else
    segura=0
    echo "ERROR: Tiene menos de 12 caracteres"
fi

# . significa cualquier carácter.
# {12,} significa 12 o más repeticiones.
# Por tanto, .{12,} comprueba que haya al menos 12 caracteres.
# La condición [[ $password =~ .{12,} ]] devuelve verdadero si encuentra una coincidencia.

# 2. Comprobar que contiene al menos un número

if [[ $password =~ [0-9] ]]; then
    echo "OK: Contiene al menos un número"
else
    segura=0
    echo "ERROR: No contiene ningún número"
fi

# [0-9] representa cualquier dígito del 0 al 9.
# No lleva + ni {n} porque solo necesitamos encontrar un número, no exigir una cantidad concreta.
# Si encuentra al menos uno, entra en la rama then; si no, ejecuta else.

# 3. Comprobar que contiene al menos una mayúscula

if [[ $password =~ [A-Z] ]]; then
    echo "OK: Contiene al menos una mayúscula"
else
    segura=0
    echo "ERROR: No contiene ninguna mayúscula"
fi

# [A-Z] representa cualquier letra mayúscula de la A a la Z.
# No hace falta utilizar +, porque solo exigimos que aparezca al menos una.


# 4. Comprobar que contiene al menos un símbolo

if [[ $password =~ [^a-zA-Z0-9] ]]; then
    echo "OK: Contiene al menos un símbolo"
else
    segura=0
    echo "ERROR: No contiene ningún símbolo"
fi

# usamos [^a-zA-Z0-9] para considerar símbolo cualquier carácter que no sea una letra inglesa ni un número. Esto también incluye espacios y algunos caracteres acentuados

# 5. Comprobar que la contraseña no aparece en el diccionario español
if grep -iwq "$password" /usr/share/dict/spanish; then
    segura=0
    echo "ERROR: La contraseña aparece en el diccionario"
else
    echo "OK: La contraseña no aparece en el diccionario"
fi

#¿Qué significa cada opción de grep?
# -i: ignora las diferencias entre mayúsculas y minúsculas.
# -w: busca la palabra completa.
# -q: no muestra el texto encontrado; solo devuelve el resultado de la búsqueda.

echo "------------------------------"

if [[ $segura -eq 1 ]]; then
    echo "RESULTADO: CONTRASEÑA SEGURA"
else
    echo "RESULTADO: CONTRASEÑA NO SEGURA"
fi
