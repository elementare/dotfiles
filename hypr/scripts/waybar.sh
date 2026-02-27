#!/bin/bash

# Mata todas as instâncias existentes do waybar
pkill -x waybar

# Aguarda um breve momento para garantir que o processo foi finalizado
sleep 0.1

# Inicia uma nova instância do waybar
waybar &

