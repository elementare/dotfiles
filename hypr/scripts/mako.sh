#!/bin/bash

# Mata todas as instâncias existentes do mako
pkill -x mako

# Aguarda um breve momento para garantir que o processo foi finalizado
sleep 0.1

# Inicia uma nova instância do mako com a configuração padrão
mako &

