#!/bin/bash

# Verificar que se haya proporcionado un argumento de IP
if [ $# -ne 1 ]; then
  echo "Uso: $0 <ip a escanear>"
  exit 1
fi

# Función para manejar la señal de interrupción (Ctrl + C)
function handle_interrupt() {
  echo "[*] Saliendo del programa..."
  exit 0
}

# Asignar la función handle_interrupt al manejo de la señal SIGINT
trap handle_interrupt SIGINT

# Ejecutar el primer comando de Nmap para obtener los puertos abiertos
nmap -p- -sS --open --min-rate 5000 -vvv -n -Pn "$1" -oG allPorts > /dev/null 2>&1

# Guardo los puertos abiertos para pasarselos a la siguiente funcion
ports="$(cat allPorts | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"

# Ejecutar el segundo comando de Nmap utilizando los puertos extraídos
nmap -sCV -p"$ports" "$1" -oN targeted > /dev/null 2>&1

# Limpio el archivo para evitar lineas innecesarias
tail -n +1 allPorts | head -n -1 > nmapResolution
tail -n +4 targeted | head -n -3 >> nmapResolution

# Muestro el archivo con colores usando batcat
batcat nmapResolution -l java


