#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando
set -x

# Actualizamos la lista de repositorios
 apt update
# ACtualizamos los paquetes del sistema
# apt upgrade -y

source .env

apt install mysql-server -y

#configuramos el parametro bind-address
sed -i "s/127.0.0.1/$WORDPRESS_DB_HOST/" /etc/mysql/mysql.conf.d/mysqld.cnf
#reiniciamos el servicio
systemctl restart mysql