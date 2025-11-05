#!/usr/bin/env bash

set -euo pipefail

# Colores de texto (setaf)
BLACK=$(tput setaf 0)      # Negro
RED=$(tput setaf 1)        # Rojo
GREEN=$(tput setaf 2)      # Verde
YELLOW=$(tput setaf 3)     # Amarillo
BLUE=$(tput setaf 4)       # Azul
MAGENTA=$(tput setaf 5)    # Magenta
CYAN=$(tput setaf 6)       # Cian
WHITE=$(tput setaf 7)      # Blanco

# Colores de fondo (setab)
BG_BLACK=$(tput setab 0)   # Fondo negro
BG_RED=$(tput setab 1)     # Fondo rojo
BG_GREEN=$(tput setab 2)   # Fondo verde
BG_YELLOW=$(tput setab 3)  # Fondo amarillo
BG_BLUE=$(tput setab 4)    # Fondo azul
BG_MAGENTA=$(tput setab 5) # Fondo magenta
BG_CYAN=$(tput setab 6)    # Fondo cian
BG_WHITE=$(tput setab 7)   # Fondo blanco

# Resetear colores
RESET=$(tput sgr0)

# Rutas
FLOG="systemMonitor.logs"
DLOG="/home/$USER/backup_logs"

# Numero limite
NUM=66

# Comandos
ROOT=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
USED=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
FREE=$(free -m | awk '/Mem:/ {print $4}')
SWAP=$(free | awk '/Swap:/ {if ($2==0) print 0; else printf "%.0f", $3/$2*100}')
HOME=$(df /home | tail -1 | awk '{print $5}' | tr -d '%')
PROCESS=$(ps ax --no-headers | wc -l)

# Funcion que valida la existencia de la ruta
dlog (){
  if [ -d "$DLOG" ]; then
    echo "El Directorio existe"
  else
    echo "El Directorio no existe"
    mkdir $DLOG
    echo "Creando directorio..." && sleep 3
  fi
}

# @cmd Verifica el % usado en raiz
root (){
  msn="$(date) ${BG_RED}Alerta:${ROOT}%${RESET} mayor o igual al ${NUM}%"
  msn1="$(date) ${GREEN}${ROOT}%${RESET} menor al ${NUM}%"

  dlog # validacion de directorio

  if [[ "$ROOT" -ge "$NUM" ]]; then
    echo "$msn" | tee -a "${DLOG}/${FLOG}"
     tail -n 1 "${DLOG}/${FLOG}" | mail -s "$msn" "$USER" #Mail Local
  else
    echo "$msn1" | tee -a "${DLOG}/${FLOG}"
  fi
}

# @cmd Uso del CPU en %
cpu (){

  echo "CPU:"

  while true; do printf "${YELLOW}\r%.2f%%${RESET}" "$(top -bn1 | grep "Cpu(s)" | awk '{print $2
 + $4}')"; sleep 1; done
}

# @cmd Memoria usada
used (){
  
  msn="$(date) ${BG_RED}Alerta:${USED}%${RESET} mayor o igual al ${NUM}%"
  msn1="$(date) ${GREEN}${USED}%${RESET} menor al ${NUM}%"

  dlog  # validacion de directorio

  if [[ "$USED" -ge "$NUM" ]]; then
    echo "$msn" | tee -a "${DLOG}/${FLOG}"
     tail -n 1 "${DLOG}/${FLOG}" | mail -s "$msn" "$USER" #Mail Local
  else
    echo "$msn1" | tee -a "${DLOG}/${FLOG}"
  fi

}

# @cmd Memoria libre
free (){
  num=1000

  msn="$(date) ${BG_RED}Alerta:${FREE}M${RESET} menor o igual al ${num}M"
  msn1="$(date) ${GREEN}${FREE}M${RESET} mayor al ${num}M"

  dlog  # validacion de directorio

  if [[ "$FREE" -lt "$num" ]]; then
    echo "$msn" | tee -a "${DLOG}/${FLOG}"
     tail -n 1 "${DLOG}/${FLOG}" | mail -s "$msn" "$USER" #Mail Local
  else
    echo "$msn1" | tee -a "${DLOG}/${FLOG}"
  fi
}

# @cmd Swap usado en %
swap (){
  
  msn="$(date) ${BG_RED}Alerta:${SWAP}%${RESET} mayor o igual al ${NUM}%"
  msn1="$(date) ${GREEN}${SWAP}%${RESET} menor al ${NUM}%"

  dlog  # validacion de directorio

  if [[ "$SWAP" -ge "$NUM" ]]; then
    echo "$msn" | tee -a "${DLOG}/${FLOG}"
     tail -n 1 "${DLOG}/${FLOG}" | mail -s "$msn" "$USER" #Mail Local
  else
    echo "$msn1" | tee -a "${DLOG}/${FLOG}"
  fi
}

# @cmd Cantidad de memoria usada en el Home
home (){
  
  msn="$(date) ${BG_RED}Alerta:${HOME}%${RESET} mayor o igual al ${NUM}%"
  msn1="$(date) ${GREEN}${HOME}%${RESET} menor al ${NUM}%"

  dlog  # validacion de directorio

  if [[ "$HOME" -ge "$NUM" ]]; then
    echo "$msn" | tee -a "${DLOG}/${FLOG}"
     tail -n 1 "${DLOG}/${FLOG}" | mail -s "$msn" "$USER" #Mail Local
  else
    echo "$msn1" | tee -a "${DLOG}/${FLOG}"
  fi
}

# @cmd Numero de procesos 
process (){
  
  echo "N.Procesos: ${MAGENTA}${PROCESS}${RESET}"
}

# @cmd Eliminar logs
clean (){
  echo "${YELLOW}Eliminando Logs...${RESET}" 
  > ${DLOG}/${FLOG} && sleep 3 && echo "${GREEN}Completado${RESET}"
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
