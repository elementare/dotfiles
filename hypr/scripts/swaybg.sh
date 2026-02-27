#!/bin/bash

# Mata todas as instâncias existentes do swaybg
pkill -x swaybg

# Aguarda um breve momento para garantir que o processo foi finalizado
sleep 0.1

# Inicia uma nova instância do swaybg com o papel de parede desejado
swaybg -i /home/elementare/.config/hypr/walls/wall-04.webp -m fill &

