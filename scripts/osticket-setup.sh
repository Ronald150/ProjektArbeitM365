#!/bin/bash

# Farben initialisieren
YELLOW="\033[33m"
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[94m"
MAGENTA="\033[95m"
COLOR_END="\033[0m"

# osTicket Umgebung vorbereiten
set -e
exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1

# Funktion 1: Abhaengigkeiten installieren
echo -e "$YELLOW[i]$COLOR_END Updates und Abhaengigkeiten installieren..."
apt-get update && apt-get upgrade -y
apt-get install -y apache2 php php-imap php-common php-curl php-intl php-cli php-mysql mysql-server unzip wget

echo -e "$GREEN[+]$COLOR_END Updates und Abhaengigkeiten wurden installiert."

# Funktion 2: MySQL konfigurieren
echo -e "$YELLOW[i]$COLOR_END MySQL konfigurieren..."
DB_NAME="osticket_db"
DB_USER="osticket_user"
DB_PASSWORD="sichere_password"

mysql -e "CREATE DATABASE $DB_NAME;"
mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mysql -e "FLUSH PRIVILEGES;"

sed -i "s/bind-address.*/bind-address=0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

echo -e "$GREEN[+]$COLOR_END MySQL wurde erfolgreich konfiguriert."

# Funktion 3: osTicket installieren
echo -e "$YELLOW[i]$COLOR_END osTicket herunterladen und einrichten..."
OS_TICKET_URL="https://github.com/osTicket/osTicket/releases/download/v1.17.2/osTicket-v1.17.2.zip"
INSTALL_DIR="/var/www/osticket"

mkdir -p $INSTALL_DIR
wget $OS_TICKET_URL -O /tmp/osticket.zip
unzip /tmp/osticket.zip -d $INSTALL_DIR
cp $INSTALL_DIR/upload/* $INSTALL_DIR/
rm -rf $INSTALL_DIR/upload /tmp/osticket.zip

chown -R www-data:www-data $INSTALL_DIR
chmod -R 755 $INSTALL_DIR

echo -e "$GREEN[+]$COLOR_END osTicket wurde heruntergeladen und eingerichtet."

# Funktion 4: Apache konfigurieren
echo -e "$YELLOW[i]$COLOR_END Apache konfigurieren..."
cat << EOF > /etc/apache2/sites-available/osticket.conf
<VirtualHost *:80>
    ServerAdmin admin@osticket.local
    DocumentRoot $INSTALL_DIR
    ServerName osticket.local

    <Directory $INSTALL_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

a2ensite osticket.conf
a2enmod rewrite
systemctl restart apache2

echo -e "$GREEN[+]$COLOR_END Apache wurde erfolgreich konfiguriert."

# Funktion 5: osTicket konfigurieren
echo -e "$YELLOW[i]$COLOR_END osTicket konfigurieren..."
cp $INSTALL_DIR/include/ost-sampleconfig.php $INSTALL_DIR/include/ost-config.php
sed -i "s/'DBNAME', 'osTicket'/'DBNAME', '$DB_NAME'/" $INSTALL_DIR/include/ost-config.php
sed -i "s/'DBUSER', 'osticket'/'DBUSER', '$DB_USER'/" $INSTALL_DIR/include/ost-config.php
sed -i "s/'DBPASS', 'password'/'DBPASS', '$DB_PASSWORD'/" $INSTALL_DIR/include/ost-config.php
chown www-data:www-data $INSTALL_DIR/include/ost-config.php
chmod 0644 $INSTALL_DIR/include/ost-config.php

echo -e "$GREEN[+]$COLOR_END osTicket wurde erfolgreich konfiguriert."

# Bereitstellung abschliessen
echo -e "$GREEN[+]$COLOR_END Die osTicket Umgebung ist fertig installiert!"
