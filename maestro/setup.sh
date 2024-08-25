#!/bin/bash

# Configuración del servidor DNS Maestro

# Se actualiza la maquina para
sudo apt update

# Se instala el paquete bind9 con las otras dependencias
sudo apt-get -y install bind9 bind9utils bind9-doc

# Se copia el archivo de configuracion de bind9 predeterminado a un backup
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local_backup

# Se copia el archivo de configuración del repositorio a la carpeta de configuración de bind9
sudo cp named.conf.local /etc/bind/

# Se copia el archivo de zona
sudo cp db.byteme.com /etc/bind/

# Crear el directorio para los archivos de zona
sudo mkdir -p /var/cache/bind
sudo chown bind:bind /var/cache/bind

# Se reinicia el servicio para aplicar los cambios
sudo systemctl restart bind9

# Configuración de servidor Apache

# Instalamos apache2 en la maquina
sudo apt-get -y install apache2

# Instalamos la librería de Apache2 para usar una autenticación de tipo PAM
sudo apt-get -y install libapache2-mod-authnz-pam

# Habilitar el modulo en apache2
sudo a2enmod authnz_pam

# Crear la carpeta y añadir los permisos del grupo www-data
sudo mkdir /var/www/html/archivos_privados
sudo chown www-data.www-data /var/www/html/archivos_privados -R

# Copiar la configuración de apache2 en sites-available
sudo cp 000-default.conf /etc/apache2/sites-available/

# Copiar el archivo con la lista para denegar el acceso a determinados usuarios
sudo cp authusers /etc/

# Copiar el archivo de apache para la configuración del PAM
sudo cp apache /etc/pam.d/

# Darle permiso al servicio de apache para leer el archivo shadow
sudo usermod -a -G shadow www-data
sudo chown root:shadow /etc/shadow
sudo chmod g+r /etc/shadow

# Reiniciar el servicio de apache2
sudo systemctl restart apache2

# Montamos web de la empresa
sudo cp -r web/* /var/www/html/

# Ahora lo que faltaría es configurar un usuario de invitado para probar la autenticación
echo "Introduzca una contraseña para el usuario invitado"
echo "Cualquier otra información puede saltarsela dando enter"
sudo adduser guest