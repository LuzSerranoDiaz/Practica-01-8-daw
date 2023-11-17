#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando
set -x

# Actualizamos la lista de repositorios
 apt update
# ACtualizamos los paquetes del sistema
# apt upgrade -y

apt install mysql-server -y