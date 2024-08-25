
# Configuración de Servidor DNS Maestro/Esclavo y Autenticación PAM en Apache

## Primera Parte: Configuración de DNS Maestro/Esclavo

### Configuración del Servidor DNS Maestro (VM1)

1. **Instalar Bind9:**
   ```bash
   sudo apt-get install bind9 bind9utils bind9-doc
   ```

2. **Configurar el archivo de zona:**
   - Edita el archivo `/etc/bind/named.conf.local` para incluir la configuración del DNS maestro.
   ```bash
   sudo nano /etc/bind/named.conf.local
   ```

   - Agrega la siguiente configuración:
   ```bash
   zone "byteme.com" {
       type master;
       file "/etc/bind/db.byteme.com";
       allow-transfer { 192.168.50.2; };  # IP del esclavo
   };
   ```

### Configuración del Servidor DNS Esclavo (VM2)

1. **Instalar Bind9:**
   ```bash
   sudo apt-get install bind9 bind9utils bind9-doc
   ```

2. **Configurar el archivo de zona esclavo:**
   - Edita el archivo `/etc/bind/named.conf.local` para incluir la configuración del DNS esclavo.
   ```bash
   sudo nano /etc/bind/named.conf.local
   ```

   - Agrega la siguiente configuración:
   ```bash
   zone "byteme.com" {
       type slave;
       masters { 192.168.50.3; };  # IP del maestro
       file "/var/cache/bind/db.byteme.com";
   };
   ```

3. **Crear el Directorio para los Archivos de Zona:**
   ```bash
   sudo mkdir -p /var/cache/bind
   sudo chown bind:bind /var/cache/bind
   ```

4. **Verificar la Configuración en la Máquina Esclavo:**
   ```bash
   dig @192.168.50.2 www.byteme.com
   ```

## Segunda Parte: Configuración de Autenticación PAM en Apache

1. **Instalar Apache2:**
   ```bash
   sudo apt-get -y install apache2
   ```

2. **Instalar la librería authnz-pam:**
   ```bash
   sudo apt-get -y install libapache2-mod-authnz-pam
   ```

3. **Habilitar la autenticación PAM en Apache:**
   ```bash
   sudo a2enmod authnz_pam
   ```

4. **Crear la carpeta /archivos_privados y añadirle permisos al grupo www-data**
   - Ejecutamos ambos comandos para 
   ```bash
   sudo mkdir /var/www/html/archivos_privados
   sudo chown www-data.www-data /var/www/html/archivos_privados -R
   ```

5. **Configurar Apache para usar PAM:**
   - Edita el archivo de configuración de Apache para el sitio.
   ```bash
   sudo nano /etc/apache2/sites-available/000-default.conf
   ```

   - Agrega la siguiente configuración para proteger el directorio `/archivos_privados`:
   ```apache
   <Directory "/var/www/html/archivos_privados">
            AuthType Basic
            AuthName "Restricted Content"
            AuthBasicProvider PAM
            AuthPAMService apache
            Require valid-user
   </Directory>
   ```

6. **Crear el archivo para negar acceso a determinados usuarios**
   - Nos dirigimos a la carpeta /etc/
   ```bash
   sudo vim authusers
   ```
   - Ponemos en la lista el usuario que deseamos restringir
   ```txt
   guest
   ```

7. **Realizamos la configuración PAM para apache**
   - Creamos un nuevo archivo en /etc/pam.d/ llamado "apache"
   ```bash
   sudo touch /etc/pam.d/apache
   ```

   - En este archivo pondremos las siguientes directivas
   ```txt
   auth requisite pam_unix.so
   account required pam_listfile.so item=user sense=deny onerr=fail file=/etc/authusers
   ```

8. **Le damos permiso al servicio de apache para leer el archivo shadow**
   - Realizamos esta acción para que apache sea capaz de autenticar mediante los usuarios registrados en la maquina.
   ```bash
   sudo usermod -a -G shadow www-data
   sudo chown root:shadow /etc/shadow
   sudo chmod g+r /etc/shadow
   ```

9. **Hecho esto reiniciamos el servicio**
   - Reiniciamos el servicio mediante systemctl.
   ```bash
   sudo systemctl restart apache2
   ```

9. **Creamos el usuario**
   - Para completar y comprobar nuestra configuración podemos crear un usuario.
   ```bash
   sudo adduser guest
   ```
