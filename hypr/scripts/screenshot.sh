#!/bin/bash

# Diretório onde salvamos as capturas
save_dir="$HOME/Pictures/Screenshots"
mkdir -p "$save_dir"

# Nome do arquivo da screenshot
timestamp=$(date '+%Y%m%d-%H:%M:%S')
output_file="$save_dir/satty-$timestamp.png"

# Captura e prepara para edição no Satty
capture_and_prepare() {
    wl-copy --type image/png < "$output_file" &  # Copia imediatamente para o clipboard
    satty --filename "$output_file" --fullscreen --output-filename "$output_file"  # Abre Satty para edição opcional
}
# capture_and_prepare() {
#     cat "$output_file" | clipse -c
#     satty --filename "$output_file" --fullscreen --output-filename "$output_file"  # Abre Satty para edição opcional
# }
case "$1" in
    "window")
        grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" -t png "$output_file"
        capture_and_prepare
        ;;
    "monitor")
        grim -t png "$output_file"
        capture_and_prepare
        ;;
    "region")
        grim -g "$(slurp -c '#ff40ef' -b '#3c284f70')" -t png "$output_file"
        capture_and_prepare
        ;;
    *)
        echo "Uso: $0 {window|monitor|region}"
        exit 1
        ;;
esac

