#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando (x) y parar en error(e)
set -ex

source .env

# Actualizamos la lista de repositorios
 apt update
# ACtualizamos los paquetes del sistema
# apt upgrade -y

# Eliminamos descargas previas de wp-cli
rm -rf /tmp/wp-cli.phar

# Descargamos la herramienta wp-cli
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Le damos permisos de ejecución
chmod +x /tmp/wp-cli.phar

# Movemos el archivo a /usr/local/bin
mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos instalaciones previas de WordPress
rm -rf /var/www/html/*

#Descargamos el codigo fuente de wordpress
wp core download \
  --locale=es_ES \
  --path=/var/www/html \
  --allow-root

#creacion del archivo de configuracion
wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --dbhost=$IP_PRIVADA_MYSQL \
  --path=/var/www/html \
  --allow-root

#Instalacion de wordpress
wp core install \
  --url=$CERTIFICATE_DOMAIN \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASS \
  --admin_email=$WORDPRESS_ADMIN_EMAIL \
  --path=/var/www/html \
  --allow-root  

# Instalamos un tema de WordPress
wp theme install joyas-shop --activate --path=/var/www/html --allow-root

# Instalamos un plugin para esconder la ruta wp-admin de wordpress
wp plugin install wps-hide-login --path=/var/www/html --allow-root

# Modificarmos los premisos de /var/www/html
chown -R www-data:www-data /var/www/html
