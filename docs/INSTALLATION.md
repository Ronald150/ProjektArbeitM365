# Installationsanleitung für osTicket auf AWS

Diese Anleitung führt Sie durch die Schritte zur Installation und Bereitstellung von osTicket auf AWS mithilfe der bereitgestellten Skripte. Die Bereitstellung erfolgt unter Verwendung des Windows Subsystem for Linux (WSL) und der AWS CLI.

---

## Navigation auf AWS Academy Learner Lab

### 1. Zugriff auf das Dashboard

1. Melden Sie sich auf der AWS Academy-Plattform an.
2. Navigieren Sie zum Dashboard Ihres Kurses, z. B. "AWS Academy Learner Lab [90559]". 

![Dashboard](https://github.com/user-attachments/assets/251d7847-3d0f-4fbe-afd8-fe43fb070310)

### 2. Auswahl des Kurses

1.  Klicken Sie in der Kursübersicht auf "AWS Academy Learner Lab [90559]".
2. Die Module und Lerninhalte des Kurses werden angezeigt.

![Kursübersicht](https://github.com/user-attachments/assets/9288e15e-6c3e-4319-b7bd-b400095e69cb)

### 3. Module aufrufen

1. Klicken Sie im linken Menü auf "Modules".
2. Wählen Sie das Modul "Launch AWS Academy Learner Lab" aus.

![Module aufrufen](https://github.com/user-attachments/assets/e1d86555-7776-4660-b9d7-89610f30c076)

### 4. Starten des AWS Academy Learner Lab

1. Finden Sie das Modul "Launch AWS Academy Learner Lab" und klicken Sie darauf.
2. Die Lab-Umgebung wird in einem Terminal-Fenster geöffnet.

![Lab starten](https://github.com/user-attachments/assets/24a7b968-0c37-413f-8dd5-be4af12a92a7)

### 5. Navigieren in der Lab-Umgebung

1. Nach dem Start sehen Sie ein Terminal mit einer funktionierenden AWS CLI-Installation.
2. Zusätzliche Dokumentationen und Ressourcen sind auf der rechten Seite einsehbar.

![Lab-Umgebung](https://github.com/user-attachments/assets/5c2a56aa-38e0-48e4-9067-8ec407722722)

---

## Voraussetzungen

### Installation von AWS CLI

Das `iac-init.sh`-Skript überprüft bereits, ob AWS CLI installiert ist. Falls nicht, wird es automatisch installiert. Sollte dies aus irgendeinem Grund fehlschlagen, können Sie die AWS CLI manuell installieren:

1. **Herunterladen der Installationsdateien**:
   Öffnen Sie ein Terminal und führen Sie diesen Befehl aus:

   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   ```

2. **Installation der AWS CLI**:
   Führen Sie den folgenden Befehl aus, um die AWS CLI zu installieren:

   ```bash
   sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
   ```

3. **Überprüfung der Installation**:
   Testen Sie, ob die AWS CLI korrekt installiert wurde:

   ```bash
   aws --version
   ```

### Konfiguration von AWS CLI

1. **AWS CLI konfigurieren**:
   Führen Sie den folgenden Befehl aus und geben Sie Ihre AWS-Zugangsdaten ein:

   ```bash
   aws configure
   ```

   - **AWS Access Key ID**: Ihren Zugriffsschlüssel.
   - **AWS Secret Access Key**: Ihren geheimen Schlüssel.
   - **Default region name**: Geben Sie `us-east-1` ein oder eine Region Ihrer Wahl.
   - **Default output format**: Lassen Sie dies leer oder geben Sie `json` ein.

2. **Manuelle Konfiguration** (optional):

   - Navigieren Sie zu Ihrem Home-Verzeichnis und erstellen Sie einen Ordner `.aws`:
     ```bash
     cd ~
     mkdir aws
     cd aws
     ```

      ![WSL_Showcase](https://github.com/user-attachments/assets/4b4d4e11-494a-4f6d-a75b-7137c284dd15)


   - Erstellen Sie zwei Dateien mit den Namen `credentials` und `config`:
     ```bash
     touch credentials config
     ```
      ![Folders](https://github.com/user-attachments/assets/4a40ef4f-5929-44ac-9430-e8bb4f343b1c)



   - Öffnen Sie die Datei `credentials` und fügen Sie Ihre Zugangsdaten ein:
     ```bash
     nano credentials
     ```

     Beispielinhalt:
     ```plaintext
     [default]
     aws_access_key_id = <Ihre_Access_Key_ID>
     aws_secret_access_key = <Ihr_Secret_Access_Key>
     ```
      ![AWS_Credentials](https://github.com/user-attachments/assets/30e41f8b-8887-4f10-8aa8-08d8cd5914ae)



   - Öffnen Sie die Datei `config` und fügen Sie Ihre Standardregion hinzu:
     ```bash
     nano config
     ```
     Beispielinhalt:
     ```plaintext
     [default]
     region = us-east-1
     ```
   - Speichern Sie beide Dateien und testen Sie die Konfiguration erneut mit:
     ```bash
     aws s3 ls
     ```

Bevor Sie beginnen, stellen Sie sicher, dass die folgenden Voraussetzungen erfüllt sind:

1. **Windows Subsystem for Linux (WSL)**: Installiert und eingerichtet auf Ihrem Windows-System.

   - Installieren Sie WSL, indem Sie PowerShell als Administrator öffnen und folgenden Befehl ausführen:
     ```powershell
     wsl --install
     ```
   - Nach der Installation starten Sie Ihr System neu, falls erforderlich.
   - Wählen Sie eine Linux-Distribution wie Ubuntu aus dem Microsoft Store und richten Sie diese ein.

2. **AWS CLI**: Installiert und konfiguriert innerhalb der WSL-Umgebung.

   - Installieren Sie die AWS CLI mit folgenden Befehlen:
     ```bash
     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
     apt install zip
     unzip awscliv2.zip
     sudo ./aws/install
     ```
   - Überprüfen Sie die Installation:
     ```bash
     aws --version
     ```
   - Konfigurieren Sie die AWS CLI mit Ihren Zugangsdaten:
     ```bash
     aws configure
     ```
     Geben Sie folgende Informationen ein:
     - **AWS Access Key ID**: Ihren Zugriffsschlüssel.
     - **AWS Secret Access Key**: Ihren geheimen Schlüssel.
     - **Default region name**: Geben Sie `us-east-1` ein oder eine Region Ihrer Wahl.
     - **Default output format**: Lassen Sie dies leer oder geben Sie `json` ein.

3. **SSH-Schlüsselpaar**: Erstellen Sie ein Schlüsselpaar für den Zugriff auf EC2-Instanzen.

   - Erstellen Sie den Schlüssel über die AWS Management Console oder führen Sie diesen Befehl aus:
     ```bash
     aws ec2 create-key-pair --key-name osTicketKey --query 'KeyMaterial' --output text > osTicketKey.pem
     chmod 400 osTicketKey.pem
     ```

4. **IAM-Berechtigungen**: Stellen Sie sicher, dass Ihr AWS-Benutzer über die folgenden Berechtigungen verfügt:

   - EC2: Vollzugriff
   - VPC: Vollzugriff
   - S3: Vollzugriff (optional für spätere Integrationen)

---

## Schritt-für-Schritt-Anleitung

### 1. Repository klonen

Klonen Sie das Repository und wechseln Sie in das Projektverzeichnis:

```bash
git clone https://github.com/your-repository/osTicket-AWS.git
cd osTicket-AWS
```

### 2. Skripte ausführbar machen

Machen Sie die erforderlichen Skripte im `scripts/`-Verzeichnis ausführbar:

```bash
chmod +x scripts/iac-init.sh scripts/iac-clean.sh scripts/mysql-setup.sh scripts/osticket-setup.sh
```

### 3. Deployment starten

Führen Sie das `iac-init.sh`-Skript aus, um die Bereitstellung der Infrastruktur und osTicket zu starten:

```bash
./scripts/iac-init.sh
```

Dieses Skript führt folgende Aktionen aus:

- Erstellt Sicherheitsgruppen für MySQL und osTicket.
- Generiert ein Schlüsselpaar für den SSH-Zugriff (falls nicht vorhanden).
- Startet EC2-Instanzen für MySQL und osTicket.
- Führt die Setup-Skripte für MySQL und osTicket aus.

### 4. Zugriff auf osTicket

Nach Abschluss der Bereitstellung zeigt das Skript die öffentliche IP-Adresse der osTicket-Instanz an. Verwenden Sie diese Adresse, um osTicket im Browser zu öffnen:

```
http://<public-ip>
```

Ersetzen Sie `<public-ip>` durch die ausgegebene IP-Adresse.

---

## Anpassung

### MySQL-Konfiguration

- Öffnen Sie die Datei `scripts/mysql-setup.sh` und passen Sie die folgenden Parameter an:
  - **DB\_NAME**: Name der Datenbank.
  - **DB\_USER**: Benutzername für die Datenbank.
  - **DB\_PASSWORD**: Passwort für den Benutzer.

### osTicket-Konfiguration

- Bearbeiten Sie die Datei `scripts/osticket-setup.sh`, um folgende Einstellungen anzupassen:
  - **SITE\_TITLE**: Titel Ihrer osTicket-Seite.
  - **ADMIN\_USER**: Admin-Benutzername.
  - **ADMIN\_PASSWORD**: Admin-Passwort.
  - **ADMIN\_EMAIL**: E-Mail-Adresse des Administrators.

---

## Bereinigung der Ressourcen

Nach Abschluss Ihrer Tests oder bei Nichtgebrauch können Sie alle erstellten Ressourcen entfernen. Führen Sie dazu das `iac-clean.sh`-Skript aus:

```bash
./scripts/iac-clean.sh
```

Dieses Skript:

- Beendet und entfernt alle EC2-Instanzen.
- Löscht die erstellten Sicherheitsgruppen.
- Entfernt das generierte SSH-Schlüsselpaar.

---

## Troubleshooting

### Häufige Probleme

1. **Fehler: `Unable to locate credentials`**

   - Stellen Sie sicher, dass die AWS CLI konfiguriert ist:
     ```bash
     aws configure
     ```

2. **SSH-Verbindung zu EC2 nicht möglich**

   - Überprüfen Sie, ob die Sicherheitsgruppe Port 22 für SSH-Zugriff erlaubt.

3. **osTicket-Seite lädt nicht**

   - Überprüfen Sie die Logs auf der osTicket-Instanz unter:
     ```bash
     /var/log/user-data.log
     ```

4. **Fehlermeldungen bei der Skriptausführung**

   - Prüfen Sie, ob alle Skripte im `scripts/`-Verzeichnis ausführbar sind:
     ```bash
     chmod +x scripts/*.sh
     ```

