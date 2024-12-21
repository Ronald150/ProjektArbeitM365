# Anleitung: Verwendung von AWS CLI im AWS Academy Learner Lab und osTicket-Projektbereitstellung

## Einleitung

Diese Anleitung beschreibt, wie Sie das AWS CLI im AWS Academy Learner Lab starten und verwenden, um ein osTicket-Ticketsystem mit MySQL-Datenbank als Infrastructure as Code (IaC) bereitzustellen. Sie dient als Dokumentation für das GitHub-Repository und beinhaltet eine detaillierte Erklärung der Skripte.

---

## Verwendung des AWS Academy Learner Labs

### 1. Zugriff auf das Dashboard

1. Melden Sie sich auf der AWS Academy-Plattform an.
2. Navigieren Sie zum Dashboard Ihres Kurses, z. B. "AWS Academy Learner Lab [90559]" (siehe Bild 1).

![image1](https://github.com/user-attachments/assets/251d7847-3d0f-4fbe-afd8-fe43fb070310)


### 2. Auswahl des Kurses

1. Klicken Sie in der Kursübersicht auf "AWS Academy Learner Lab [90559]" (siehe Bild 2).
2. Die Module und Lerninhalte des Kurses werden angezeigt.

![image2](https://github.com/user-attachments/assets/9288e15e-6c3e-4319-b7bd-b400095e69cb)


### 3. Module aufrufen

1. Klicken Sie im linken Menü auf "Modules" (siehe Bild 3).
2. Wählen Sie das Modul "Launch AWS Academy Learner Lab" aus.

![image3](https://github.com/user-attachments/assets/e1d86555-7776-4660-b9d7-89610f30c076)


### 4. Starten des AWS Academy Learner Lab

1. Finden Sie das Modul "Launch AWS Academy Learner Lab" und klicken Sie darauf (siehe Bild 4).
2. Die Lab-Umgebung wird in einem Terminal-Fenster geöffnet.

![image4](https://github.com/user-attachments/assets/24a7b968-0c37-413f-8dd5-be4af12a92a7)


### 5. Navigieren in der Lab-Umgebung

1. Nach dem Start sehen Sie ein Terminal mit einer funktionierenden AWS CLI-Installation (siehe Bild 5).
2. Zusätzliche Dokumentationen und Ressourcen sind auf der rechten Seite einsehbar.

![image5](https://github.com/user-attachments/assets/5c2a56aa-38e0-48e4-9067-8ec407722722)


### 6. AWS CLI verwenden

1. Geben Sie den folgenden Befehl ein, um die AWS CLI-Version zu überprüfen:
   ```bash
   aws --version
   ```
2. Um eine Liste der verfügbaren Dienste und Befehle anzuzeigen, verwenden Sie:
   ```bash
   aws help
   ```
3. Beispiel: Starten Sie eine EC2-Instanz mit folgendem Befehl:
   ```bash
   aws ec2 run-instances --image-id ami-0abcdef1234567890 --count 1 --instance-type t2.micro
   ```

---

## osTicket-Projektbereitstellung

Die Bereitstellung des osTicket-Ticketsystems erfolgt über vorbereitete Skripte im GitHub-Repository. Nachfolgend werden die Skripte detailliert erklärt.

---

### Skripte

#### **iac-init.sh**

1. **Farbinitialisierung**:
   Zur Verbesserung der Lesbarkeit werden Farben für die Skriptausgabe definiert:

   ```bash
   YELLOW="\033[33m"
   RED="\033[31m"
   GREEN="\033[32m"
   BLUE="\033[34m"
   COLOR_END="\033[0m"
   ```

2. **Prüfung und Installation von AWS CLI**:

   Das Skript überprüft, ob AWS CLI installiert ist. Falls nicht, wird es heruntergeladen und installiert:

   ```bash
   awscli_installed=$(which aws)
   if [ -z "$awscli_installed" ]; then
       sudo apt update
       curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o ~/awscliv2.zip
       unzip ~/awscliv2.zip -d ~
       sudo ~/aws/install
   fi
   ```

3. **Erstellen von Sicherheitsgruppen**:

   Zwei Sicherheitsgruppen werden eingerichtet:

   - **osTicket-Instanz**: Ports 80 (HTTP), 443 (HTTPS), 22 (SSH).
   - **MySQL-Instanz**: Ports 3306 (Datenbankzugriff), 22 (SSH).

   Beispiel für die osTicket-Sicherheitsgruppe:

   ```bash
   OS_TICKET_SG_ID=$(aws ec2 create-security-group --group-name 'osTicket-sg' --description "osTicket SG" --query GroupId --output text)
   aws ec2 authorize-security-group-ingress --group-id $OS_TICKET_SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
   aws ec2 authorize-security-group-ingress --group-id $OS_TICKET_SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
   aws ec2 authorize-security-group-ingress --group-id $OS_TICKET_SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
   ```

4. **Erstellen eines SSH-Schlüssels**:
   Ein Key-Pair wird erstellt, um sicheren Zugriff auf die Instanzen zu ermöglichen:

   ```bash
   aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_NAME.pem
   chmod 400 $KEY_NAME.pem
   ```

5. **Bereitstellung der MySQL-Datenbank**:
   Eine EC2-Instanz für MySQL wird gestartet:

   ```bash
   DATABASE_INSTANCE_ID=$(aws ec2 run-instances \
   --image-id ami-08c40ec9ead489470 --count 1 --instance-type t2.micro \
   --security-groups mysql-sg --key-name $KEY_NAME \
   --user-data file://setup/mysql-setup.sh \
   --query 'Instances[*].InstanceId' --output text)
   ```

6. **Bereitstellung von osTicket**:
   Die osTicket-Instanz wird mit dem benutzerdefinierten Setup-Skript gestartet:

   ```bash
   OS_TICKET_INSTANCE_ID=$(aws ec2 run-instances \
   --image-id ami-08c40ec9ead489470 --count 1 --instance-type t2.micro \
   --security-groups osTicket-sg --key-name $KEY_NAME \
   --user-data file://setup/osticket-setup.sh \
   --query 'Instances[*].InstanceId' --output text)
   ```

---

#### **iac-clean.sh**

Dieses Skript stoppt alle laufenden Instanzen, entfernt die Sicherheitsgruppen und löscht das Key-Pair:

1. **Instanzen terminieren**:

   ```bash
   INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text)
   aws ec2 terminate-instances --instance-ids $INSTANCE_IDS
   ```

2. **Sicherheitsgruppen entfernen**:

   ```bash
   aws ec2 delete-security-group --group-id $OS_TICKET_SG_ID
   aws ec2 delete-security-group --group-id $MYSQL_SG_ID
   ```

3. **Key-Pair entfernen**:

   ```bash
   aws ec2 delete-key-pair --key-name $KEY_NAME
   rm -f $KEY_NAME.pem
   ```

---

## Setup-Skripte

### **mysql-setup.sh**

- Erstellt die MySQL-Datenbank und einen Benutzer für osTicket.
- Konfiguriert den Server für externe Verbindungen.

### **osticket-setup.sh**

- Installiert Apache2, PHP und osTicket.
- Konfiguriert die Verbindung zur MySQL-Datenbank.
- Aktiviert HTTPS mit einem selbstsignierten Zertifikat.

---

Diese Anleitung deckt die Schritte zur Einrichtung und Bereinigung einer osTicket-Umgebung mit AWS CLI ab. Stellen Sie sicher, dass alle Konfigurationsdateien vor der Verwendung angepasst werden.

