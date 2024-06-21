#!/bin/sh

# # ==============================================================
# # MariaDB Setup Script
# # ==============================================================
echo "[i] Starting MySQL setup script..."

# if [ ! -d "/run/mysqld" ]; then
#     echo "[i] mysqld not found, creating...."
#     mkdir -p /run/mysqld
# fi

# if [ ! -d "/var/lib/mysql" ]; then
#     echo "[i] mysql not found, creating...."
#     mkdir -p /var/lib/mysql
# fi

# chown -R mysql:mysql /run/mysqld /var/lib/mysql


# # ==============================================================
# # Initialize MySQL Data Directory
# # ==============================================================
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "[i] MySQL data directory not found, creating initial DBs"
    if mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null; then
        echo "[i] MySQL data directory initialized successfully."
    else
        echo "[e] Failed to initialize MySQL data directory."
        exit 1
    fi
fi


MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-$(pwgen 16 1)}
echo "[i] MySQL root Password: $MARIADB_ROOT_PASSWORD"

# # ==============================================================
# # Prepare SQL Commands for User and Database Initialization
# # ==============================================================
tfile=$(mktemp)
if [ ! -f "$tfile" ]; then
    echo "[e] Failed to create temporary file."
    exit 1
fi

cat << EOF > $tfile
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE user='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE db='test';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS \`$WP_DATABASE_NAME\`;
CREATE USER IF NOT EXISTS '$WP_DATABASE_USR'@'%' IDENTIFIED BY '$WP_DATABASE_PWD';
GRANT ALL PRIVILEGES ON \`$WP_DATABASE_NAME\`.* TO '$WP_DATABASE_USR'@'%';
CREATE USER IF NOT EXISTS '$WP_DATABASE_USR'@'%' IDENTIFIED BY '$WP_DATABASE_PWD';
GRANT ALL PRIVILEGES ON \`$WP_DATABASE_NAME\`.* TO '$WP_DATABASE_USR'@'%';
FLUSH PRIVILEGES;

EOF

# # ==============================================================
# # Run MySQL in bootstrap mode to initialize database and users
# # ==============================================================
/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile

rm -f $tfile



echo "[i] Database and users created successfully."


# # ==============================================================
# # Execute Pre-execution Scripts if Any
# # ==============================================================
for i in /scripts/pre-exec.d/*sh
do
    if [ -e "${i}" ]; then
        echo "[i] pre-exec.d - processing $i"
        . ${i}
    fi
done

echo "[i] Starting MySQL server normally..."
exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@