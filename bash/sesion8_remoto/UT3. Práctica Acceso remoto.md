¿Qué significa **fingerprint**?



El **fingerprint** es una huella digital de la clave pública del servidor. Permite identificarlo y comprobar su identidad en futuras conexiones.



Al escribir yes, has aceptado esa identidad y SSH ha guardado la información del servidor en tu equipo.



2\. ¿Qué archivo se ha modificado?

El archivo es:

\~/.ssh/known\_hosts





Este fichero almacena las huellas de los servidores SSH a los que te has conectado y aceptado.



Puedes comprobarlo desde otra terminal de tu Ubuntu (no desde la sesión remota):

cat \~/.ssh/known\_hosts





Verás una entrada correspondiente a \[localhost]:2222.



**Respuesta**:

**\*\*Nivel 1.1. Conexión SSH mediante contraseña\*\***



Para conectarme al servidor remoto he utilizado el comando:




ssh -p 2222 soporte@localhost



En la primera conexión, SSH muestra un mensaje de fingerprint o huella digital. Esta huella permite identificar la clave pública del servidor y comprobar su identidad.



Al aceptar la conexión escribiendo `yes`, SSH guarda la huella del servidor en el fichero `\\\~/.ssh/known\\\_hosts` de mi equipo local.



A continuación, he introducido la contraseña del usuario `soporte` y he conseguido acceder correctamente al servidor Ubuntu 24.04.



\*\*Comprobación de la conexión remota\*\*



Una vez establecida la conexión SSH, he ejecutado los siguientes comandos:



\- `whoami`: devuelve `soporte`, confirmando el usuario remoto.

\- `hostname`: muestra `0d9f013ed64f`, que identifica el contenedor Docker.

\- `pwd`: muestra `/home/soporte`, indicando el directorio actual.



Los resultados confirman que la conexión se ha realizado correctamente al servidor Ubuntu 24.04.



**\*\*Nivel 1.2 y 1.3. Autenticación mediante claves SSH\*\***



He generado un par de claves SSH utilizando el algoritmo ed25519 mediante el comando:



ssh-keygen -t ed25519 -C "franc-aso"



Las claves se han guardado en el directorio `\~/.ssh/`:



\- `id\_ed25519`: clave privada, que permanece en el equipo local y nunca debe compartirse.

\- `id\_ed25519.pub`: clave pública, que se copia al servidor remoto.



Para copiar la clave pública he utilizado:



ssh-copy-id -p 2222 soporte@localhost



La clave se ha añadido al fichero `/home/soporte/.ssh/authorized\_keys` del servidor.



Finalmente, he comprobado la autenticación ejecutando:



ssh -p 2222 soporte@localhost



La conexión se ha establecido correctamente sin solicitar la contraseña del usuario, demostrando que la autenticación mediante claves SSH funciona.



**\*\*Nivel 1.4. Configuración de un alias SSH\*\***



He creado el fichero `\~/.ssh/config` en mi equipo local con la siguiente configuración:





Host servidor

&#x20;   HostName localhost

&#x20;   Port 2222

&#x20;   User soporte





Esta configuración permite establecer un alias llamado `servidor`, que guarda los datos de conexión: nombre del equipo, puerto y usuario.



He comprobado su funcionamiento ejecutando:



ssh servidor





La conexión se ha establecido correctamente y sin solicitar contraseña, gracias a la autenticación mediante claves SSH configurada anteriormente.



**\*\*Nivel 2.1. Consulta de información del servidor\*\***



Dentro de la sesión SSH he ejecutado los siguientes comandos:



&#x20;Comando  			Resultado

&#x20;`whoami` 			soporte

&#x20;`pwd`				/home/soporte

&#x20;`df -h` 			Muestra el espacio utilizado y disponible en disco.

&#x20;`ps aux` 			Muestra los procesos en ejecución.

&#x20;`ps aux \\| grep sshd` 		Localiza los procesos relacionados con el servidor SSH.



Mediante estas comprobaciones he confirmado que estoy conectado al servidor con el usuario `soporte`, situado en `/home/soporte`.



También he consultado el espacio en disco y los procesos activos. Finalmente, he localizado el proceso principal `sshd`, encargado de aceptar conexiones SSH, así como los procesos asociados a mi sesión remota.



**\*\*Nivel 2.2. Ejecución de comandos remotos sin sesión interactiva\*\***



He ejecutado comandos en el servidor remoto desde mi equipo local, sin abrir una sesión interactiva.



Para esto he utilizamos servidor, que es el alias SSH, y las órdenes entre comillas simples.



La conexión se abre, ejecuta el comando y se cierra automáticamente.



Primera orden:



ssh servidor 'df -h'



Permite consultar el espacio en disco del servidor remoto.



Segunda orden:



ssh servidor 'ls -l datos/facturas'



Muestra el contenido del directorio `datos/facturas`, donde aparecen las cinco facturas creadas.



En ambos casos, SSH establece la conexión, ejecuta el comando solicitado en el servidor y finaliza la conexión automáticamente al terminar.



Por tanto, son accesos no orientados a sesión, ya que no se mantiene una terminal interactiva abierta.



**\*\*Nivel 2.3. Contar archivos mediante SSH y una tubería\*\***



He utilizado el siguiente comando:



ssh servidor 'ls datos/facturas' | wc -l



El resultado obtenido ha sido 5, que corresponde al número de facturas existentes en el servidor.



La primera parte, `ssh servidor 'ls datos/facturas'`, se ejecuta en el servidor remoto y devuelve el listado de archivos.



La segunda parte, `wc -l`, se ejecuta en mi equipo local y cuenta las líneas recibidas.



El símbolo `|` (tubería) conecta ambos comandos, enviando la salida del primero como entrada del segundo.



**Nivel 2.4 – Crear un fichero en el servidor mediante un comando remoto**



He utilizado el siguiente comando:



ssh servidor 'touch prueba\_remota.txt'



Que conecta con el servidor y crea un archivo vacío si este no existe, con el nombre del archivo que vamos a crear.



Para comprobar esto,



ssh servidor 'ls -l prueba\_remota.txt'



**\*\*Nivel 2.5. Clasificación de los accesos\*\***



Los accesos realizados se clasifican en dos tipos:



\- Orientado a sesión: `ssh servidor`. Permite abrir una terminal interactiva en el servidor remoto, donde podemos ejecutar diferentes comandos hasta cerrar la conexión mediante `exit`.



\- No orientado a sesión: los comandos `ssh servidor 'df -h'`, `ssh servidor 'ls -l datos/facturas'`, `ssh servidor 'ls datos/facturas' | wc -l` y `ssh servidor 'touch prueba\_remota.txt'`. En estos casos se ejecuta una operación concreta y la conexión SSH finaliza automáticamente cuando termina el comando.



La diferencia principal es que el acceso orientado a sesión mantiene una terminal interactiva abierta, mientras que el no orientado a sesión ejecuta una orden puntual.





**\*\*Nivel 4.2.1. Comparación de dos ejecuciones de rsync\*\***



He ejecutado dos veces consecutivas el script `backup\_rsync.sh`.



En la primera ejecución, rsync ha copiado todos los directorios y archivos del origen remoto al destino local `\~/backups/espejo`.



En la segunda ejecución, al no haber cambiado ningún archivo, rsync ha comprobado el contenido y no ha vuelto a transferir los archivos.



Esto demuestra que rsync realiza una sincronización incremental, transfiriendo únicamente los archivos nuevos o modificados y evitando transferencias innecesarias.



**\*\*Nivel 4.2.2. Modificación de un archivo y nueva sincronización\*\***



Primero he consultado el contenido original de `factura\_3.txt` mediante SSH. Después, he modificado su contenido desde el equipo local utilizando un comando remoto.



A continuación, he vuelto a ejecutar:



./backup\_rsync.sh datos



Rsync ha detectado el cambio y ha transferido únicamente:



facturas/factura\_3.txt



Finalmente, he comprobado el contenido de la copia local:



cat \~/backups/espejo/facturas/factura\_3.txt



El resultado ha sido `Factura 3 modificada`.



Esto demuestra que rsync detecta los archivos modificados y evita volver a transferir los que permanecen iguales.



**\*\*Nivel 4.2.3. Diferencia de la barra final en rsync\*\***



La barra final `/` en la ruta de origen cambia el comportamiento de rsync:



\- Sin barra final (`servidor:datos`): copia el directorio `datos` dentro del destino.

\- Con barra final (`servidor:datos/`): copia directamente el contenido del directorio `datos` dentro del destino.



En esta práctica utilizamos `servidor:datos/` porque queremos que las carpetas `clientes` y `facturas` queden directamente dentro de `\~/backups/espejo`.



**\*\*Nivel 4.2.4. Conclusión: ¿cuándo utilizar SCP y cuándo rsync?\*\***



Utilizaría SCP para realizar copias puntuales de archivos o directorios completos, cuando necesito transferirlos de un equipo a otro.



Utilizaría rsync para realizar copias periódicas o incrementales, ya que compara el contenido del origen y del destino y transfiere únicamente los archivos nuevos o modificados.



Por tanto, SCP es adecuado para transferencias sencillas y rsync es más eficiente cuando necesitamos mantener copias actualizadas.



**\*\*Nivel 5.1. Cifrado de las transferencias\*\***



Sí, los datos transferidos mediante SCP y rsync viajan cifrados en esta práctica.



Ambas herramientas utilizan SSH como protocolo de transporte. SSH cifra la comunicación entre el equipo local y el servidor remoto, protegiendo los archivos transferidos frente a posibles interceptaciones.



**\*\*Nivel 5.2. Consulta de los registros de Docker\*\***



He consultado los registros del contenedor mediante el comando:





sudo docker logs servidor





En los registros he identificado diferentes eventos relacionados con las conexiones SSH:



\- `Accepted password for soporte`: indica que se ha aceptado una conexión mediante contraseña.

\- `Accepted publickey for soporte`: indica que se ha aceptado una conexión mediante clave pública.

\- `Disconnected from user soporte`: indica que se ha cerrado una conexión del usuario.



Estos registros permiten comprobar los accesos realizados al servidor y el método de autenticación utilizado.

