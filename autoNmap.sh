#!/bin/bash

# Ejecutar el primer comando de Nmap para obtener los puertos abiertos
nmap -p- --open --min-rate 5000 -n -Pn "$1" -oG allPorts > /dev/null 2>&1

# Guardo los puertos abiertos para pasarselos a la siguiente funcion
ports="$(cat allPorts | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"

# Ejecutar el segundo comando de Nmap utilizando los puertos extraídos
nmap -sCV -p"$ports" "$1" -oN targeted > /dev/null 2>&1

# Limpio el archivo para evitar lineas innecesarias
tail -n +1 allPorts | head -n -1 > nmapResolution
tail -n +4 targeted | head -n -3 >> nmapResolution

# Muestro el archivo con colores usando batcat
batcat nmapResolution -l java

