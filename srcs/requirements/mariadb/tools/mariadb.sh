#!/bin/bash

# Iniciar el servicio de MariaDB
service mariadb start 

# Esperar un momento para asegurar que el servicio esté en funcionamiento
sleep 5

# Comprobar si la base de datos ya existe
if [ ! -d /var/lib/mysql/${MYSQL_DATABASE} ]; then
    # Crear la base de datos
    mysql -u ${MYSQL_ROOT_USER} -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${MYSQL_DATABASE};"
    
    # Crear el usuario y otorgar permisos
    mysql -u ${MYSQL_ROOT_USER} -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u ${MYSQL_ROOT_USER} -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -u ${MYSQL_ROOT_USER} -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

# Cerrar el servidor de MariaDB
mysqladmin -u ${MYSQL_ROOT_USER} -p${MYSQL_ROOT_PASSWORD} shutdown

# Iniciar el servidor de MariaDB
exec mysqld
