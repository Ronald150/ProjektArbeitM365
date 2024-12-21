#!/bin/bash

# Aktivieren des Loggings
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Farben initialisieren
YELLOW="\033[33m"
RED="\033[31m"
GREEN="\033[32m"
COLOR_END="\033[0m"

# MySQL-Installation und Konfiguration
echo -e "$YELLOW[i]$COLOR_END Update und Installation von MySQL..."
apt-get update
apt-get install -y mysql-server

# MySQL-Datenbank und Benutzer erstellen
DB_NAME="osticket"
DB_USER="osticket_user"
DB_PASSWORD="sicheres_passwort"

mysql -e "CREATE DATABASE $DB_NAME;"
mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# MySQL Root-Passwort setzen
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root_sicheres_passwort';"

# MySQL für externe Verbindungen konfigurieren
echo -e "$YELLOW[i]$COLOR_END MySQL für externe Verbindungen konfigurieren..."
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

echo -e "$GREEN[+]$COLOR_END MySQL-Setup abgeschlossen."
