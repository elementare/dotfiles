#!/bin/bash

# Caminho para salvar a imagem temporária
temp_img="/tmp/ocr_clipboard_image.png"

# Salva imagem do clipboard
clipse -p > "$temp_img"

# Faz OCR com Tesseract (japonês + chinês simplificado + inglês)
ocr_result=$(tesseract "$temp_img" - -l jpn+chi_sim+eng 2>/dev/null)
# Se o OCR falhar ou estiver vazio
if [ -z "$ocr_result" ]; then
    zenity --error --text="OCR falhou ou não detectou texto." --title="Erro de OCR"
    exit 1
fi

ocr_cleaned=$(echo "$ocr_result" | perl -CS -pe 's/([\p{Hiragana}\p{Katakana}\p{Han}]) ([\p{Hiragana}\p{Katakana}\p{Han}])/$1$2/g')



# Copia o texto extraído pro clipboard (Wayland)
echo "$ocr_cleaned" | clipse -c

# Mostra o texto em uma janela gráfica com scroll
zenity --info --width=600 --height=400 \
    --text="$(echo "$ocr_cleaned" | sed 's/&/\&/g')" \
    --title="Texto extraído por OCR"

