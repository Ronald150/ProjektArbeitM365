#!/bin/bash

# Aktivieren des Loggings
# Alle Ausgaben werden in eine Log-Datei geschrieben, um Debugging zu erleichtern
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Farben initialisieren
# Diese Farben werden verwendet, um die Ausgaben im Terminal besser sichtbar zu machen
YELLOW="\033[33m"
RED="\033[31m"
GREEN="\033[32m"
COLOR_END="\033[0m"

# MySQL-Installation und Konfiguration
echo -e "$YELLOW[i]$COLOR_END Update und Installation von MySQL..."
# MySQL-Server und benötigte Pakete installieren
apt-get update
apt-get install -y mysql-server

# MySQL-Datenbank und Benutzer erstellen
# Name der Datenbank, Benutzer und Passwort festlegen
DB_NAME="osticket"
DB_USER="osticket_user"
DB_PASSWORD="sicheres_passwort"

# Erstellen der MySQL-Datenbank und des Benutzers mit entsprechenden Berechtigungen
echo -e "$YELLOW[i]$COLOR_END Erstelle Datenbank und Benutzer..."
mysql -e "CREATE DATABASE $DB_NAME;"
mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Root-Passwort für MySQL festlegen
# Standardmässig hat der Root-Benutzer kein Passwort. Dies wird hier gesetzt.
echo -e "$YELLOW[i]$COLOR_END Setze MySQL Root-Passwort..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root_sicheres_passwort';"

# MySQL für externe Verbindungen konfigurieren
# Standardmässig erlaubt MySQL keine externen Verbindungen. Diese werden hier aktiviert.
echo -e "$YELLOW[i]$COLOR_END Konfiguriere MySQL für externe Verbindungen..."
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

echo -e "$GREEN[+]$COLOR_END MySQL-Setup abgeschlossen."
