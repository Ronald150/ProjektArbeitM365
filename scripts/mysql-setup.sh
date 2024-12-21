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

# Sicherheitsgruppen erstellen oder wiederverwenden
# MySQL Sicherheitsgruppe
MYSQL_SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=mysql-sg" --query "SecurityGroups[*].GroupId" --output text)
if [ -z "$MYSQL_SG_ID" ]; then
  MYSQL_SG_ID=$(aws ec2 create-security-group --group-name "mysql-sg" --description "Sicherheitsgruppe für MySQL" --output text)
  echo -e "$GREEN[+]$COLOR_END MySQL Sicherheitsgruppe erstellt: $MYSQL_SG_ID"
  aws ec2 authorize-security-group-ingress --group-id $MYSQL_SG_ID --protocol tcp --port 3306 --cidr 0.0.0.0/0
  aws ec2 authorize-security-group-ingress --group-id $MYSQL_SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
else
  echo -e "$YELLOW[i]$COLOR_END MySQL Sicherheitsgruppe existiert bereits: $MYSQL_SG_ID"
fi

# osTicket Sicherheitsgruppe
OSTICKET_SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=osticket-sg" --query "SecurityGroups[*].GroupId" --output text)
if [ -z "$OSTICKET_SG_ID" ]; then
  OSTICKET_SG_ID=$(aws ec2 create-security-group --group-name "osticket-sg" --description "Sicherheitsgruppe für osTicket" --output text)
  echo -e "$GREEN[+]$COLOR_END osTicket Sicherheitsgruppe erstellt: $OSTICKET_SG_ID"
  aws ec2 authorize-security-group-ingress --group-id $OSTICKET_SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
  aws ec2 authorize-security-group-ingress --group-id $OSTICKET_SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
  aws ec2 authorize-security-group-ingress --group-id $OSTICKET_SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
else
  echo -e "$YELLOW[i]$COLOR_END osTicket Sicherheitsgruppe existiert bereits: $OSTICKET_SG_ID"
fi

# MySQL-Installation und Konfiguration
echo -e "$YELLOW[i]$COLOR_END Update und Installation von MySQL..."
# Aktualisieren der Paketliste und Installieren des MySQL-Servers
apt-get update
apt-get install -y mysql-server

# MySQL-Datenbank und Benutzer erstellen
# Name der Datenbank, Benutzer und Passwort festlegen
DB_NAME="osticket_db"   # Der Name der Datenbank, die für osTicket verwendet wird
DB_USER="ost_user"     # Der Benutzername für die Verbindung zur MySQL-Datenbank
DB_PASSWORD="mY_v3ry_$3cur3_p@ssw0rd!" # Sicheres Passwort für den Benutzer

# Sicherstellen, dass die Variablen gesetzt sind
if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
  echo -e "$RED[!]$COLOR_END Fehler: DB_NAME, DB_USER oder DB_PASSWORD ist nicht gesetzt."
  exit 1
fi

# Erstellen der MySQL-Datenbank und des Benutzers mit entsprechenden Berechtigungen
echo -e "$YELLOW[i]$COLOR_END Erstelle Datenbank und Benutzer..."
mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"  # Bestehende Datenbank entfernen, falls vorhanden
mysql -e "CREATE DATABASE $DB_NAME;"  # Datenbank erstellen
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"  # Benutzer mit Passwort erstellen
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"  # Alle Rechte für die Datenbank gewähren
mysql -e "FLUSH PRIVILEGES;"  # Berechtigungen aktualisieren

# Root-Passwort für MySQL festlegen
# Standardmässig hat der Root-Benutzer kein Passwort. Dies wird hier gesetzt.
echo -e "$YELLOW[i]$COLOR_END Setze MySQL Root-Passwort..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'r00t_v3ry_$3cur3!';"  # Sicheres Passwort für Root-Benutzer setzen

# MySQL für externe Verbindungen konfigurieren
# Standardmässig erlaubt MySQL keine externen Verbindungen. Diese werden hier aktiviert.
echo -e "$YELLOW[i]$COLOR_END Konfiguriere MySQL für externe Verbindungen..."
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf  # MySQL so konfigurieren, dass es Verbindungen von überall akzeptiert
systemctl restart mysql  # MySQL-Dienst neu starten, um Änderungen zu übernehmen

echo -e "$GREEN[+]$COLOR_END MySQL-Setup abgeschlossen."  # Erfolgsnachricht ausgeben

# osTicket installieren und konfigurieren
echo -e "$YELLOW[i]$COLOR_END Installiere Webserver und osTicket..."
apt-get install -y apache2 php libapache2-mod-php php-mysql unzip wget

# osTicket herunterladen und konfigurieren
cd /var/www/html
wget https://github.com/osTicket/osTicket/releases/download/v1.18.1/osTicket-v1.18.1.zip -O osticket.zip
unzip osticket.zip
mv upload/* .  # Verschiebe die entpackten Dateien in das Webserver-Verzeichnis
rm -rf upload osticket.zip  # Bereinigung der temporären Dateien
cp include/ost-sampleconfig.php include/ost-config.php
chmod 0666 include/ost-config.php  # Schreibrechte für die Konfigurationsdatei

# osTicket-Datenbank konfigurieren
echo -e "$YELLOW[i]$COLOR_END Konfiguriere osTicket-Datenbank..."
sed -i "s/'DBNAME', '.*'/'DBNAME', '$DB_NAME'/" include/ost-config.php
sed -i "s/'DBUSER', '.*'/'DBUSER', '$DB_USER'/" include/ost-config.php
sed -i "s/'DBPASS', '.*'/'DBPASS', '$DB_PASSWORD'/" include/ost-config.php

# Apache-Webserver neu starten
systemctl restart apache2

echo -e "$GREEN[+]$COLOR_END osTicket wurde erfolgreich installiert."  # Erfolgsnachricht ausgeben
