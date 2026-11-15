#!/bin/bash


# Listamos todos los procesos que vamos a realizar
# Función para listar los procesos de un usuario
listar_usuario() {
    # Pedir el nombre del usuario
    read -p "Introduce el nombre de usuario: " usuario

    # Comprobar que el usuario existe
    if id "$usuario" &>/dev/null; then
        echo "Procesos del usuario $usuario:"
        ps -u "$usuario" -f
    else
        echo "Error: el usuario $usuario no existe"
    fi
}

# read -p: solicita el nombre y lo guarda en la variable usuario.
# id $usuario": comprueba si existe ese usuario en el sistema.
# &>/dev/null: oculta tanto la salida como los errores del comando id. Solo nos interesa saber si ha funcionado.
# if: si el usuario existe, ejecutamos el bloque correspondiente.
# ps -u $usuario" -f: muestra los procesos de ese usuario en formato completo.
# else: si no existe, mostramos un mensaje de error.

# Función para buscar un proceso por nombre
buscar_proceso() {
    # Pedir el nombre del proceso
    read -p "Nombre del proceso: " nombre

    # Comprobar que no esté vacío
    if [[ -z "$nombre" ]]; then
        echo "Error: debes introducir un nombre"
        return 1
    fi

    echo "PID       USUARIO       %CPU     COMANDO"

    encontrados=0

    # Recorrer los procesos del sistema
    while read -r pid usuario cpu comando; do

        # Buscar coincidencias sin distinguir mayúsculas
        if [[ "${comando,,}" == *"${nombre,,}"* ]]; then
            echo "$pid   $usuario   $cpu   $comando"
            ((encontrados++))
        fi

    done < <(ps -eo pid=,user=,%cpu=,comm=)

    # Comprobar si se ha encontrado algún proceso
    if [[ $encontrados -eq 0 ]]; then
        echo "No hay ningún proceso que coincida con $nombre"
    fi
}

# -z: comprueba si una cadena de texto está vacía.
# return 1: termina la función indicando que ha habido un error.
# Creamos una variable llamada encontrados y le damos el valor inicial 0. La utilizaremos para contar procesos que coincidan con la busqueda.
# pid usuario cpu comando: son las cuatro variables donde guardamos los datos de cada proceso.
# -eo -e: muestra todos los procesos. -o: permite seleccionar las columnas que queremos mostrar.
# ${comando,,}: convierte el nombre del proceso a minúsculas.
# ${nombre,,}: convierte lo que hemos escrito a minúsculas.
# ==: compara ambos valores.
# *: representa cualquier conjunto de caracteres.

# Función para mostrar los procesos que más CPU consumen
top_cpu() {
    # Establecer el número de procesos (por defecto, 5)
    cantidad=${1:-5}

    # ${1} representa el primer parámetro que recibe la función.
    # :-5 significa que, si no recibe ningún parámetro o está vacío, utiliza el valor 5.
    # cantidad es la variable donde guardamos el número.

    # Comprobar que el número sea válido
    if [[ ! $cantidad =~ ^[0-9]+$ ]] || [[ $cantidad -eq 0 ]]; then
        echo "Error: debes indicar un número mayor que 0"
        return 1
    fi

    # !: niega una condición.
    # =~: comprueba si el contenido cumple una expresión regular.
    # ^[0-9]+$: exige que sea un número entero formado por uno o más dígitos.
    # ||: significa O. Basta con que una de las dos condiciones sea verdadera.
    # -eq: compara si dos números son iguales.

    # Mostrar los procesos ordenados por consumo de CPU
    echo "Los $cantidad procesos que más CPU consumen:"
    ps -eo pid,user,%cpu,comm --sort=-%cpu | head -n "$((cantidad + 1))"
}

    # comm: nombre del comando.
    # --sort=-%cpu: ordena los procesos por consumo de CPU de mayor a menor. El signo - indica orden descendente. 
    # head: muestra las primeras líneas.
    # -n: indica cuántas líneas queremos mostrar.
    # $((...)): permite realizar operaciones aritméticas. En sete caso le suma 1 a cantidad


# Función validar_pid
validar_pid() {
    pid="$1"

    # Comprobar que el PID sea numérico
    if [[ ! $pid =~ ^[0-9]+$ ]]; then
        return 1
    fi

    # Comprobar que el proceso existe
    if ps -p "$pid" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}


# Función para cambiar la prioridad de un proceso

cambiar_prioridad() {
    # Pedir el PID
    read -p "PID: " pid

    # Comprobar que el PID existe
    if ! validar_pid "$pid"; then
        echo "Error: el PID no es válido o el proceso no existe"
        return 1
    fi

    # Pedir la nueva prioridad
    read -p "Nuevo valor nice: " nuevo_nice

    # Comprobar que sea un número entero
    if [[ ! $nuevo_nice =~ ^-?[0-9]+$ ]]; then
        echo "Error: debes introducir un número entero"
        return 1
    fi

    # Comprobar los límites de nice
    if [[ $nuevo_nice -lt -20 || $nuevo_nice -gt 19 ]]; then
        echo "Error: el valor debe estar entre -20 y 19"
        return 1
    fi

    # Comprobar si el usuario es root
    if [[ $EUID -ne 0 && $nuevo_nice -lt 0 ]]; then
        echo "Error: solo root puede establecer valores negativos"
        return 1
    fi

    # Obtener el nombre del proceso
    comando=$(ps -p "$pid" -o comm=)

    # Cambiar la prioridad
    if renice "$nuevo_nice" -p "$pid"; then
        echo "Prioridad del proceso $pid modificada correctamente"

        # Registrar el cambio en el fichero de log Ejercicio 8
        echo "$(date '+%Y-%m-%d %H:%M:%S') - renice $nuevo_nice - $pid - $comando" >> ~/gestion_procesos.log
    else
        echo "Error: no se pudo cambiar la prioridad"
    fi
}


# Función para finalizar un proceso

finalizar_proceso() {
    # Pedir el PID
    read -p "PID: " pid

    # Comprobar que el PID existe
    if ! validar_pid "$pid"; then
        echo "Error: el PID no es válido o el proceso no existe"
        return 1
    fi

    # Obtener el nombre del proceso
    comando=$(ps -p "$pid" -o comm=)

    # Pedir confirmación
    read -p "¿Finalizar $pid ($comando)? (s/n): " respuesta

    if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then

        # Enviar la señal SIGTERM
        if kill -SIGTERM "$pid"; then
            sleep 3

            # Comprobar si el proceso sigue activo
            if ps -p "$pid" > /dev/null 2>&1; then
                # Enviar la señal SIGKILL
                # 1. kill -SIGTERM $pid". Envía la señal SIGTERM al proceso.
                if kill -SIGKILL "$pid"; then
                    echo "Proceso $pid finalizado con SIGKILL"
                    echo "$(date '+%Y-%m-%d %H:%M:%S') - SIGKILL - $pid - $comando" >> ~/gestion_procesos.log
                else
                    echo "Error: no se pudo finalizar el proceso"
                fi
            else
                echo "Proceso $pid finalizado con SIGTERM"
                echo "$(date '+%Y-%m-%d %H:%M:%S') - SIGTERM - $pid - $comando" >> ~/gestion_procesos.log
            fi
        else
            echo "Error: no se pudo enviar SIGTERM"
        fi

    elif [[ "$respuesta" == "n" || "$respuesta" == "N" ]]; then
        echo "Operación cancelada"
    else
        echo "Error: debes responder s o n"
    fi
}


# Menú principal
while true; do
    echo "===== GESTIÓN DE PROCESOS ====="
    echo "1) Listar los procesos de un usuario"
    echo "2) Buscar un proceso por nombre"
    echo "3) Mostrar los N procesos que más CPU consumen"
    echo "4) Cambiar la prioridad de un proceso"
    echo "5) Finalizar un proceso"
    echo "6) Salir"

    read -p "Opción: " opcion

    case $opcion in
        1)
            listar_usuario
            ;;
        2)
            buscar_proceso
            ;;
        3)
            top_cpu
            ;;
        4)
            cambiar_prioridad
            ;;
        5)
            finalizar_proceso
            ;;
        6)
            echo "Saliendo del programa..."
            break
            ;;
        *)
            echo "Error: opción no válida"
            ;;
    esac
done


# while true: crea un bucle que se repite continuamente.
# read -p: muestra un mensaje y guarda lo que escribimos en una variable.
# case: comprueba qué opción hemos seleccionado.
# ;;: termina cada alternativa del case.
# break: sale del bucle cuando elegimos la opción 6.
