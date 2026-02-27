#!/bin/bash

set -euo pipefail

# Dependências: flameshot, wl-copy, jq, hyprctl, xdg-desktop-portal e xdg-desktop-portal-hyprland rodando

save_dir="$HOME/Pictures/Screenshots"
mkdir -p "$save_dir"

timestamp="$(date '+%Y%m%d-%H:%M:%S')"
output_file="$save_dir/flameshot-$timestamp.png"

copy_and_save() {
  # lê PNG do stdin, salva no arquivo e copia pro clipboard
  tee "$output_file" >/dev/null | true
  wl-copy --type image/png < "$output_file"
}

active_monitor_index() {
  # tenta mapear o monitor focado do Hyprland para um índice
  # o Flameshot usa índices zero baseados na ordem que o Qt vê
  # Na maioria dos setups isto bate com a ordem do hyprctl
  hyprctl monitors -j \
    | jq 'map({name: .name, focused: .focused}) 
          | to_entries 
          | map(select(.value.focused)) 
          | (.[0].key // 0)'
}

case "${1:-}" in
  window)
    # seleção interativa, confirma e fecha automático
    # -r envia PNG no stdout para encadear
    flameshot gui --accept-on-select -r | copy_and_save
    ;;

  monitor)
    idx="$(active_monitor_index)"
    # captura do monitor atual, se -n não funcionar no teu Flameshot, cai para full
    if flameshot screen -n "$idx" -r >/dev/null 2>&1; then
      flameshot screen -n "$idx" -r | copy_and_save
    else
      flameshot full -r | copy_and_save
    fi
    ;;

  region)
    # seleção livre
    flameshot gui -r | copy_and_save
    ;;

  *)
    echo "Uso: $0 {window|monitor|region}"
    exit 1
    ;;
esac

echo "Salvo em: $output_file"

