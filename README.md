# osTicket Deployment with AWS

## Übersicht
Dieses Projekt automatisiert die Bereitstellung einer osTicket-Instanz auf AWS mithilfe von Infrastructure as Code (IaC) Skripten. Es umfasst Setup-Skripte für MySQL, osTicket sowie Bereinigungstools, um Ressourcen nach der Nutzung zu entfernen.

---

## Funktionen
- **Automatisierte Bereitstellung**: osTicket und eine MySQL-Datenbank werden automatisch auf AWS EC2-Instanzen bereitgestellt.
- **AWS CLI Integration**: Verwendet AWS CLI für die Erstellung und Verwaltung von Ressourcen.
- **Individuelle Konfiguration**: Benutzerdefinierte Einstellungen für Datenbank- und osTicket-Konfigurationen möglich.
- **Bereinigungstools**: Entfernt alle während der Bereitstellung erstellten AWS-Ressourcen.

---

## Projektstruktur

### Verzeichnis: `scripts/`
- **[`iac-init.sh`](scripts/iac-init.sh)**: Initialisiert die AWS-Umgebung, erstellt Sicherheitsgruppen, startet EC2-Instanzen und richtet osTicket und MySQL ein.
- **[`mysql-setup.sh`](scripts/mysql-setup.sh)**: Konfiguriert den MySQL-Server, erstellt die Datenbank und bereitet sie für osTicket vor.
- **[`osticket-setup.sh`](scripts/osticket-setup.sh)**: Installiert und konfiguriert osTicket, einschließlich Datenbankverbindung und Webserver-Einstellungen.
- **[`iac-clean.sh`](scripts/iac-clean.sh)**: Bereinigt die Umgebung durch Beenden der Instanzen, Entfernen der Sicherheitsgruppen und Löschen des SSH-Schlüssels.


### Verzeichnis: `docs/`
- **[`INSTALLATION.md`](docs/INSTALLATION.md)**: Detaillierte Installationsanleitung.
- **[`TESTING.md`](docs/TESTING.md)**: Hinweise und Anleitungen zum Testen der Bereitstellung.
- **[`SECURITY_AND_DEVOPS.md`](docs/SECURITY_AND_DEVOPS.md)**: Sicherheits- und DevOps-Best Practices.
- **[`REFLECTION.md`](docs/REFLECTION.md)**: Projektreflexion und Lessons Learned.

---

## Voraussetzungen
1. **AWS Account**: Zugriff auf ein AWS-Konto.
2. **AWS CLI**: Installiert und konfiguriert auf Ihrem lokalen Rechner.
3. **SSH Key Pair**: Ein Schlüsselpaar für den Zugriff auf EC2-Instanzen.
4. **IAM-Berechtigungen**: Benutzer mit Berechtigungen für EC2, S3 und VPC.

---

## Deployment-Schritte

### 1. Repository klonen
```bash
git clone https://github.com/your-repository/osTicket-AWS.git
cd osTicket-AWS
```

### 2. Skripte ausführbar machen
```bash
chmod +x scripts/iac-init.sh scripts/iac-clean.sh scripts/mysql-setup.sh scripts/osticket-setup.sh
```

### 3. Deployment starten
Führen Sie das Initialisierungsskript aus, um die Ressourcen bereitzustellen und osTicket einzurichten:
```bash
./scripts/iac-init.sh
```

### 4. osTicket aufrufen
Nach der Bereitstellung zeigt das Skript die öffentliche IP-Adresse der osTicket-Instanz an. Verwenden Sie diese, um osTicket im Browser zu öffnen.

---

## Bereinigung
Um alle erstellten AWS-Ressourcen zu entfernen, führen Sie das Bereinigungsskript aus:
```bash
./scripts/iac-clean.sh
```

---

## Anpassung
- **MySQL-Einstellungen**: Aktualisieren Sie den Datenbanknamen, Benutzer und das Passwort in `mysql-setup.sh`.
- **osTicket-Konfiguration**: Passen Sie Einstellungen wie den Seitentitel in `osticket-setup.sh` an.
- **Terraform**: Nutzen Sie das Verzeichnis `terraform` für erweiterte IaC-Setups.

---

## Fehlerbehebung
- **Logs**: Prüfen Sie `/var/log/user-data.log` auf den EC2-Instanzen bei Setup-Fehlern.
- **AWS CLI-Fehler**: Stellen Sie sicher, dass AWS CLI korrekt konfiguriert ist.
- **Berechtigungen**: Überprüfen Sie die IAM-Berechtigungen, wenn Ressourcen nicht erstellt werden können.

---

## Mitwirkende
- **Ronald Klauser**
- **Gian Luca Hörler**
- **Milan Fenner**

---

## Lizenz
Dieses Projekt steht unter der MIT-Lizenz. Weitere Informationen finden Sie in der Datei [`LICENSE.md`](LICENSE.md).

