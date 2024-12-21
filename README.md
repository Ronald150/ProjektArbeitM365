# osTicket-Bereitstellung mit AWS

## Überblick
Dieses Projekt automatisiert die Bereitstellung einer osTicket-Instanz auf AWS mithilfe von Infrastructure as Code (IaC)-Skripten. Es umfasst Setup-Skripte für MySQL, osTicket und Bereinigungstools, um Ressourcen zu entfernen, wenn sie nicht mehr benötigt werden.

---

## Funktionen
- **Automatisierte Bereitstellung**: Richtet osTicket und eine MySQL-Datenbank auf AWS EC2-Instanzen ein.
- **AWS-Integration**: Verwendet die AWS CLI zur Erstellung und Verwaltung von Ressourcen.
- **Individuelle Konfiguration**: Ermöglicht benutzerdefinierte Einstellungen für die Datenbank- und osTicket-Konfiguration.
- **Bereinigungstools**: Entfernt alle während der Bereitstellung erstellten AWS-Ressourcen.

---

## Dateien und Verzeichnisse

### **Bereitstellungsskripte**
- **`iac-init.sh`**: Initialisiert die AWS-Umgebung, erstellt Sicherheitsgruppen, startet EC2-Instanzen und richtet osTicket sowie MySQL ein.
- **`mysql-setup.sh`**: Konfiguriert den MySQL-Server, erstellt die Datenbank und bereitet sie für osTicket vor.
- **`osticket-setup.sh`**: Installiert und konfiguriert osTicket, einschliesslich der Datenbankverbindung und der Webserver-Einstellungen.

### **Bereinigungsskript**
- **`iac-clean.sh`**: Beendet EC2-Instanzen, löscht Sicherheitsgruppen und entfernt das SSH-Schlüsselpaar.

### **Vorlagen und Konfigurationen**
- **`osticket-cloud-init.yml`**: Cloud-Init-Konfiguration zur Automatisierung des osTicket-Setups während des EC2-Instanzstarts.
- **Terraform-Verzeichnis**: Enthält `main.tf` zur Definition der AWS-Infrastruktur mithilfe von Terraform (optional).

---

## Voraussetzungen
1. **AWS-Konto**: Stellen Sie sicher, dass Sie Zugriff auf ein AWS-Konto haben.
2. **AWS CLI**: Auf Ihrem lokalen Rechner installiert und konfiguriert.
3. **Schlüsselpaar**: SSH-Schlüsselpaar für den Zugriff auf EC2-Instanzen.
4. **Berechtigungen**: IAM-Benutzer mit Berechtigungen für EC2, S3 und VPC.

---

## So wird die Bereitstellung durchgeführt

### 1. Klonen Sie das Repository
```bash
git clone https://github.com/your-repository/osTicket-AWS.git
cd osTicket-AWS
```

### 2. Machen Sie die Skripte ausführbar
```bash
chmod +x iac-init.sh iac-clean.sh setup/mysql-setup.sh setup/osticket-setup.sh
```

### 3. Führen Sie das Bereitstellungsskript aus
Führen Sie das Initialisierungsskript aus, um Ressourcen bereitzustellen und osTicket einzurichten:
```bash
./iac-init.sh
```

### 4. Greifen Sie auf osTicket zu
Nach der Bereitstellung gibt das Skript die öffentliche IP-Adresse der osTicket-Instanz aus. Verwenden Sie diese, um osTicket in Ihrem Browser aufzurufen.

---

## Ressourcen bereinigen
Um Instanzen zu beenden und AWS-Ressourcen zu entfernen, führen Sie das Bereinigungsskript aus:
```bash
./iac-clean.sh
```

---

## Anpassungen
- **MySQL-Einstellungen**: Aktualisieren Sie den Datenbanknamen, den Benutzer und das Passwort in `mysql-setup.sh`.
- **osTicket-Konfiguration**: Passen Sie `osticket-setup.sh` an, um benutzerdefinierte Website-Einstellungen festzulegen.
- **Terraform**: Verwenden Sie das `terraform`-Verzeichnis für erweiterte IaC-Setups.

---

## Fehlerbehebung
- **Protokolle**: Überprüfen Sie `/var/log/user-data.log` auf den EC2-Instanzen, um Setup-Fehler zu analysieren.
- **AWS CLI-Fehler**: Stellen Sie sicher, dass die CLI korrekt mit gültigen Anmeldeinformationen konfiguriert ist.
- **Berechtigungen**: Überprüfen Sie IAM-Berechtigungen, wenn Ressourcen nicht erstellt werden können.

---

## Mitwirkende
- **Ronald Klauser**
- **Gian Luca Hörler**
- **Milan Fenner**

---

## Lizenz
Dieses Projekt ist unter der MIT-Lizenz lizenziert. Siehe `LICENSE.md` für Details.

