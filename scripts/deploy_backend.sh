#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando (x) y parar en error(e)
set -ex

source .env

# Actualizamos la lista de repositorios
 apt update
# ACtualizamos los paquetes del sistema
# apt upgrade -y


# Creamos la base de datos y el usuario para wordpress
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@'$IP_CLIENTE_MYSQL'"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@'$IP_CLIENTE_MYSQL'"
