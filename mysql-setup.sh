#!/bin/bash

# Aktivieren des Loggings
# Protokolliert alle Befehle und Ausgaben in eine Log-Datei zur Fehleranalyse
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Farben initialisieren
# Farben für die Skriptausgabe zur besseren Lesbarkeit definieren
YELLOW="\033[33m"
RED="\033[31m"
GREEN="\033[32m"
COLOR_END="\033[0m"

# MySQL-Installation und Konfiguration
# Installiert MySQL-Server, um die osTicket-Datenbank zu hosten
echo -e "$YELLOW[i]$COLOR_END Update und Installation von MySQL..."
# Aktualisieren der Paketlisten und Installation des MySQL-Servers
apt-get update
apt-get install -y mysql-server

# MySQL-Datenbank und Benutzer erstellen
# Definiert die Datenbank, den Benutzer und das Passwort für osTicket
DB_NAME="osticket"
DB_USER="osticket_user"
DB_PASSWORD="sicheres_passwort"

# Erstellt die MySQL-Datenbank und den Benutzer mit den definierten Berechtigungen
echo -e "$YELLOW[i]$COLOR_END Erstelle MySQL-Datenbank und Benutzer..."
# Erstellt die Datenbank für osTicket
mysql -e "CREATE DATABASE $DB_NAME;"
# Erstellt einen Benutzer mit dem definierten Passwort und gewährt Zugriff
mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
# Erteilt dem Benutzer vollständige Rechte auf der neuen Datenbank
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
# Aktualisiert die Berechtigungen in MySQL
mysql -e "FLUSH PRIVILEGES;"

# MySQL Root-Passwort setzen
# Sichert den Root-Zugang durch Festlegen eines starken Passworts
echo -e "$YELLOW[i]$COLOR_END Setze MySQL Root-Passwort..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root_sicheres_passwort';"

# MySQL für externe Verbindungen konfigurieren
# Ermöglicht Verbindungen von externen Hosts durch Ändern der MySQL-Konfigurationsdatei
echo -e "$YELLOW[i]$COLOR_END MySQL für externe Verbindungen konfigurieren..."
# Ändert die Einstellung "bind-address", damit MySQL auf allen IP-Adressen lauscht
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Startet den MySQL-Dienst neu, um die Konfigurationsänderungen zu übernehmen
echo -e "$YELLOW[i]$COLOR_END MySQL-Dienst wird neu gestartet..."
systemctl restart mysql

# Abschlussnachricht anzeigen
echo -e "$GREEN[+]$COLOR_END MySQL-Setup abgeschlossen."

# Hinweis für den Benutzer
echo -e "$YELLOW[!]$COLOR_END Bitte überprüfen Sie, ob die MySQL-Datenbank korrekt läuft und von extern erreichbar ist."
