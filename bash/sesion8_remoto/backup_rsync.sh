#!/bin/bash

# Comprobar que se ha recibido un parámetro
if [[ $# -eq 0 ]]; then
    echo "Uso: $0 CARPETA_REMOTA"
    exit 1
fi

# Guardar la carpeta remota recibida
carpeta="$1"

#Elemento	Significado
#  $#	      Número de parámetros recibidos.
#  $0	      Nombre del propio script.
#  $1	      Primer parámetro recibido.
# -eq	      Comprueba si dos números son iguales.
# exit 1      Termina el script indicando un error.

# Crear directorio de copias
mkdir -p ~/backups

# mkdir: crea directorios.
# -p: evita errores si el directorio ya existe.
# ~: representa nuestro directorio personal (/home/usuario).


# Función para registrar el resultado
registrar() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> ~/backups/backup.log
}

# date: obtiene la fecha y hora.
# $1: recibe el mensaje que queremos registrar.
# >>: añade información al final del fichero sin borrar lo anterior.
# backup.log: archivo donde guardaremos los registros.

# Comprobar conexión con el servidor
if ! ssh -o BatchMode=yes servidor 'echo Conexion correcta'; then
    echo "Error: no se puede conectar con el servidor"
    registrar "ERROR: conexion con el servidor"
    exit 1
fi

echo "Conexión con el servidor correcta"

# -o: permite indicar opciones de configuración SSH.
# BatchMode=yes: evita que SSH solicite contraseñas o confirmaciones interactivas.
# !: invierte el resultado de la condición.
# echo Conexion correcta: ejecuta un mensaje en el servidor para comprobar que responde.
# then: ejecuta las instrucciones si la conexión falla.

# Crear destino fijo para rsync
destino="$HOME/backups/espejo"

# Crear la carpeta de destino
mkdir -p "$destino"

# Sincronizar la carpeta remota mediante rsync
if rsync -av "servidor:$carpeta/" "$destino/"; then
    echo "Sincronización realizada correctamente"
    registrar "OK - Carpeta: $carpeta - Destino: $destino"
else
    echo "Error al realizar la sincronización"
    registrar "ERROR - Carpeta: $carpeta - Destino: $destino"
    exit 1
fi
