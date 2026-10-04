#!/bin/bash


for log in "$1"/*.log; do
    if [ -f "$log" ]; then
        nombre=$(basename "$log")
        warnings=$(grep -c "WARNING" "$log")
        errores=$(grep "ERROR" "$log" | wc -l)

        echo "$nombre  -->  $warnings WARNING, $errores ERROR"
    fi
done
