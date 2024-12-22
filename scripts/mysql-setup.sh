#!/bin/bash

# Farben initialisieren
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
COLOR_END="\033[0m"

set -e  # Fehlerbehandlung aktivieren

echo -e "$YELLOW[i]$COLOR_END Update und Installation von MySQL..."
apt-get update
apt-get install -y mysql-server

DB_NAME="osticket"
DB_USER="osticket_user"
DB_PASSWORD="secure_password"

# MySQL-Datenbank und Benutzer einrichten
echo -e "$YELLOW[i]$COLOR_END Erstelle MySQL-Datenbank und Benutzer..."
mysql -e "CREATE DATABASE $DB_NAME;"
mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Root-Passwort setzen und externe Verbindungen aktivieren
echo -e "$YELLOW[i]$COLOR_END Konfiguriere MySQL-Root-Passwort und entferne Bindings..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root_password';"
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

echo -e "$GREEN[+]$COLOR_END MySQL-Setup abgeschlossen."
