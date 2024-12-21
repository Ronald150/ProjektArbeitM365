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
# Aktualisieren der Paketliste und Installieren des MySQL-Servers
apt-get update
apt-get install -y mysql-server

# MySQL-Datenbank und Benutzer erstellen
# Name der Datenbank, Benutzer und Passwort festlegen
DB_NAME="osticket_db"   # Der Name der Datenbank, die für osTicket verwendet wird
DB_USER="ost_user"     # Der Benutzername für die Verbindung zur MySQL-Datenbank
DB_PASSWORD="mY_v3ry_$3cur3_p@ssw0rd!" # Sicheres Passwort für den Benutzer

# Erstellen der MySQL-Datenbank und des Benutzers mit entsprechenden Berechtigungen
echo -e "$YELLOW[i]$COLOR_END Erstelle Datenbank und Benutzer..."
mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"  # Bestehende Datenbank entfernen, falls vorhanden
mysql -e "CREATE DATABASE $DB_NAME;"  # Datenbank erstellen
mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"  # Benutzer mit Passwort erstellen
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
# Aktualisieren der Paketliste und Installieren des MySQL-Servers
apt-get update
apt-get install -y mysql-server

# MySQL-Datenbank und Benutzer erstellen
# Name der Datenbank, Benutzer und Passwort festlegen
DB_NAME="osticket_db"   # Der Name der Datenbank, die für osTicket verwendet wird
DB_USER="ost_user"     # Der Benutzername für die Verbindung zur MySQL-Datenbank
DB_PASSWORD="mY_v3ry_$3cur3_p@ssw0rd!" # Sicheres Passwort für den Benutzer

# Erstellen der MySQL-Datenbank und des Benutzers mit entsprechenden Berechtigungen
echo -e "$YELLOW[i]$COLOR_END Erstelle Datenbank und Benutzer..."
mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"  # Bestehende Datenbank entfernen, falls vorhanden
mysql -e "CREATE DATABASE $DB_NAME;"  # Datenbank erstellen
mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"  # Benutzer mit Passwort erstellen
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
# Aktualisieren der Paketliste und Installieren des MySQL-Servers
apt-get update
apt-get install -y mysql-server

# MySQL-Datenbank und Benutzer erstellen
# Name der Datenbank, Benutzer und Passwort festlegen
DB_NAME="osticket_db"   # Der Name der Datenbank, die für osTicket verwendet wird
DB_USER="ost_user"     # Der Benutzername für die Verbindung zur MySQL-Datenbank
DB_PASSWORD="mY_v3ry_$3cur3_p@ssw0rd!" # Sicheres Passwort für den Benutzer

# Erstellen der MySQL-Datenbank und des Benutzers mit entsprechenden Berechtigungen
echo -e "$YELLOW[i]$COLOR_END Erstelle Datenbank und Benutzer..."
mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"  # Bestehende Datenbank entfernen, falls vorhanden
mysql -e "CREATE DATABASE $DB_NAME;"  # Datenbank erstellen
mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"  # Benutzer mit Passwort erstellen
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
