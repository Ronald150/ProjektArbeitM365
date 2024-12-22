#!/bin/bash

# Farben initialisieren
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
COLOR_END="\033[0m"

set -e  # Fehlerbehandlung aktivieren

echo -e "$YELLOW[i]$COLOR_END Installiere Apache2, PHP und benötigte Pakete..."
apt-get update
apt-get install -y apache2 php libapache2-mod-php php-mysql unzip wget

# osTicket herunterladen und einrichten
echo -e "$YELLOW[i]$COLOR_END Lade osTicket herunter und installiere..."
wget https://github.com/osTicket/osTicket/releases/latest/download/osTicket-latest.zip -O /tmp/osticket.zip
unzip /tmp/osticket.zip -d /var/www/html/
mv /var/www/html/upload/* /var/www/html/
rm -rf /var/www/html/upload /tmp/osticket.zip

# Berechtigungen setzen
echo -e "$YELLOW[i]$COLOR_END Setze Berechtigungen für osTicket..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Konfiguration anpassen
echo -e "$YELLOW[i]$COLOR_END Konfiguriere osTicket..."
DB_NAME="osticket"
DB_USER="osticket_user"
DB_PASSWORD="secure_password"
DB_HOST="localhost"

cat <<EOL > /var/www/html/include/ost-config.php
<?php
define('DBTYPE', 'mysql');
define('DBHOST', '$DB_HOST');
define('DBNAME', '$DB_NAME');
define('DBUSER', '$DB_USER');
define('DBPASS', '$DB_PASSWORD');
EOL

# Apache2 starten
echo -e "$YELLOW[i]$COLOR_END Starte Apache2..."
systemctl restart apache2

echo -e "$GREEN[+]$COLOR_END osTicket erfolgreich installiert! Besuchen Sie: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
