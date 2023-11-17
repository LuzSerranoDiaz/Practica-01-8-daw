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

#cambiamos el propietario y el grupo 
chown -R www-data:www-data /var/www/html/

#Habilitamos el modulo rewrite
a2enmod rewrite

#Creamos el archivo .htaccess en var/www/html
cp ../htaccess/.htaccess /var/www/html/.htaccess


systemctl restart apache2