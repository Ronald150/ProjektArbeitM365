#!/bin/bash

# Aktivieren des Loggings
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Farben initialisieren
YELLOW="\033[33m"
RED="\033[31m"
GREEN="\033[32m"
COLOR_END="\033[0m"

# Apache und PHP installieren
echo -e "$YELLOW[i]$COLOR_END Installiere Apache2 und PHP..."
apt-get update
apt-get install -y apache2 php libapache2-mod-php php-mysql unzip wget

# osTicket herunterladen und installieren
echo -e "$YELLOW[i]$COLOR_END Lade osTicket herunter..."
wget https://github.com/osTicket/osTicket/releases/latest/download/osTicket-latest.zip -O /tmp/osticket.zip
unzip /tmp/osticket.zip -d /var/www/html/
mv /var/www/html/upload/* /var/www/html/
rm -rf /var/www/html/upload /tmp/osticket.zip

# Berechtigungen setzen
echo -e "$YELLOW[i]$COLOR_END Setze Berechtigungen..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Apache konfigurieren und starten
echo -e "$YELLOW[i]$COLOR_END Konfiguriere Apache..."
a2enmod rewrite
systemctl restart apache2

# MySQL-Verbindung konfigurieren
echo -e "$YELLOW[i]$COLOR_END Konfiguriere MySQL-Verbindung..."
DB_NAME="osticket"
DB_USER="osticket_user"
DB_PASSWORD="sicheres_passwort"
DB_HOST="$1"  # Datenbank-IP von der Befehlszeile 

cat <<EOL > /var/www/html/include/ost-config.php
<?php
define('DBTYPE', 'mysql');
define('DBHOST', '$DB_HOST');
define('DBNAME', '$DB_NAME');
define('DBUSER', '$DB_USER');
define('DBPASS', '$DB_PASSWORD');
EOL

# CLI-Tool von osTicket prüfen und konfigurieren
echo -e "$YELLOW[i]$COLOR_END Konfiguriere osTicket CLI..."
if [ -f "/var/www/html/setup/cli/manage.php" ]; then
    chmod +x /var/www/html/setup/cli/manage.php
    echo -e "$GREEN[+]$COLOR_END CLI-Tool erfolgreich aktiviert."
else
    echo -e "$RED[!]$COLOR_END CLI-Tool nicht gefunden!"
fi

# HTTPS aktivieren
echo -e "$YELLOW[i]$COLOR_END Erstelle selbstsigniertes Zertifikat..."
mkdir -p /etc/apache2/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/apache2/ssl/apache-selfsigned.key \
    -out /etc/apache2/ssl/apache-selfsigned.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=example.com"

a2enmod ssl
a2ensite default-ssl
systemctl restart apache2

echo -e "$GREEN[+]$COLOR_END osTicket-Setup abgeschlossen. Besuchen Sie: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
