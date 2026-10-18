
#!/bin/bash

contador=0
re='bash$'

while read -r linea
do
     if [[ $liena =~ $re ]]; then
         usuario=${linea%%:*}
         echo "$usuario"
         ((contador++))
     fi
done < /etc/passwd

echo "Usuarios con bash: $contador"
