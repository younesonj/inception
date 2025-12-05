#!/bin/bash
set -e

echo "Starting MariaDB setup..."

# Initialize database if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not found. Initializing..."
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo "Database initialized"
fi

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Temporary start to configure
mysqld --user=mysql --bootstrap <<-EOSQL
    USE mysql;
    FLUSH PRIVILEGES;
    CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
    CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
    FLUSH PRIVILEGES;
EOSQL

echo "MariaDB setup complete! Starting server..."

# Run MariaDB in foreground (NO background process!)
exec mysqld --user=mysql