#!/bin/bash
#Muestra comandos que se van ejecutando por si falla
set -x

#Incluir variables de entorno
source .env

#Actualizamos los repos
apt update

#Actualizar paquetes 
apt upgrade -y

# Elimnamos descargas previas:

rm -rf /tmp/iaw-practica-lamp

#Clonamos el repositorio con el codigo fuente de la aplicación:

git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

#Copiamos el cod fuente de la app /var/www/html

mv /tmp/iaw-practica-lamp/src/* /var/www/html

#Configuramos el archivo config.php de la app

sed -i "s/database_name_here/ $DB_NAME/" /var/www/html/config.php

sed -i "s/username_here/ $DB_USER/" /var/www/html/config.php

sed -i "s/password_here/ $DB_PASSWORD/" /var/www/html/config.php

#Importar el script de la base de datos

mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

#Creamos usuarios con privilegios

mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%'"