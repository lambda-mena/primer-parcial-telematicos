#!/bin/bash

# Configuración del servidor DNS esclavo

# Se actualiza la maquina para
sudo apt update

# Se instala el paquete bind9 con las otras dependencias
sudo apt-get -y install bind9 bind9utils bind9-doc

# Se copia el archivo de configuracion de bind9 predeterminado a un backup
sudo cp /etc/bind/named.conf.local /esclavo/named.conf.local_backup

# Se copia el archivo de configuración del repositorio a la carpeta de configuración de bind9
sudo cp named.conf.local /etc/bind/named.conf.local

# Crear el directorio para los archivos de zona
sudo mkdir -p /var/cache/bind
sudo chown bind:bind /var/cache/bind

# Se reinicia el servicio para aplicar los cambios
sudo systemctl restart bind9