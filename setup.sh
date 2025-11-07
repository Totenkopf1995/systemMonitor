#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Interrupción detectada!"; exit' SIGINT
trap 'echo "Script finalizado."' EXIT
trap 'echo "$(date) Error en línea $LINENO con código $?" >> error.log' ERR

# Instala cargo y argc si no están instalados
instalar (){
  local -r herramienta1="cargo"

  if ! command -v "$herramienta1" > /dev/null 2>&1; then
    echo "Cargo no instalado, Instalando..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    sleep 2
    echo "Instalando argc..."
    cargo install argc
  else
    local -r herramienta2="argc"

    echo "Cargo se encuentra instalado"
    if ! command -v "$herramienta2" > /dev/null 2>&1; then
      echo "Argc no instalado, instalando..."
      cargo install argc
    else
      echo "Argc ya está instalado"
    fi
  fi
}
  
# ejecucion de la funcion
instalar

