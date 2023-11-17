#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando (x) y parar en error(e)
set -ex

source .env

# Actualizamos la lista de repositorios
 apt update
# ACtualizamos los paquetes del sistema
# apt upgrade -y

#instalamos zip
sudo apt install zip -y

#instalamos tar
sudo apt install tar

#borrar versiones anteriores en tmp wordpress
rm -rf /tmp/latest.tar
rm -rf /tmp/wordpress
rm -rf /var/www/html/wp-admin
rm -rf /var/www/html/wp-content
rm -rf /var/www/html/wp-includes



#poner wordpress en tmp
wget http://wordpress.org/latest.tar.gz -P /tmp

#descomprimimos el archivo gz
gunzip /tmp/latest.tar.gz

#descomprimimos el archivo tar
tar -xvf /tmp/latest.tar -C /tmp

#Movemos wordpress 
mv -f /tmp/wordpress/* /var/www/html

#creamos la base de datos
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@'$IP_CLIENTE_MYSQL'"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@'$IP_CLIENTE_MYSQL'"

#Creamos un archivo de configuracion 
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

#Configuramos el archivo wp-config.php
sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

#cambiamos el propietario y el grupo 
chown -R www-data:www-data /var/www/html/

#Habilitamos el modulo rewrite
a2enmod rewrite

#Creamos el archivo .htaccess en var/www/html
cp ../htaccess/.htaccess /var/www/html/.htaccess


systemctl restart apache2