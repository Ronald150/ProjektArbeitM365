# 📥 Installationsanleitung

## 📋 Inhaltsverzeichnis
- [Voraussetzungen](#voraussetzungen)
- [Installation](#installation)
- [Konfiguration](#konfiguration)
- [Verifizierung](#verifizierung)

## ⚡ Voraussetzungen
### Erforderliche Software
- [ ] AWS Account mit Admin-Rechten
- [ ] Terraform (>= 1.0.0)
- [ ] AWS CLI
- [ ] Git
- [ ] MySQL Workbench

### Erforderliche Kenntnisse
- AWS Grundlagen
- Terraform Basics
- Git Grundkenntnisse

## 🔧 Installation

### 1️⃣ Repository Setup
```bash
# Repository klonen
git clone <repository-url>
cd ticket-system

# Branches überprüfen
git branch --list
```

### 2️⃣ AWS Konfiguration
```bash
# AWS CLI konfigurieren
aws configure

# Eingaben:
# AWS Access Key ID: IHRE_ACCESS_KEY_ID
# AWS Secret Access Key: IHR_SECRET_ACCESS_KEY
# Region: eu-central-1
# Output Format: json
```

### 3️⃣ Terraform Variablen
Erstellen Sie `terraform.tfvars`:
```hcl
aws_region  = "eu-central-1"
db_name     = "osticket"
db_username = "admin"
db_password = "IhrSicheresPasswort"
```

### 4️⃣ Infrastruktur Deployment
```bash
# Initialisierung
terraform init

# Plan überprüfen
terraform plan

# Anwendung
terraform apply
```

## ⚙️ Konfiguration

### MySQL Workbench Setup
1. Öffnen Sie MySQL Workbench
2. Neue Verbindung erstellen:
   ```
   Hostname: RDS-ENDPOINT
   Port: 3306
   Username: admin
   Password: IhrSicheresPasswort
   ```

### osTicket Initialisierung
1. Browser öffnen: `http://<EC2-IP>/osTicket`
2. Setup durchführen:
    - Admin Account erstellen
    - E-Mail konfigurieren
    - Zeitzone einstellen

## ✅ Verifizierung

### Checkliste
- [ ] EC2-Instanz läuft
- [ ] RDS-Instanz läuft
- [ ] Web-Interface erreichbar
- [ ] Datenbank verbunden
- [ ] E-Mail-Versand funktioniert

### Logging
```bash
# Apache Logs prüfen
sudo tail -f /var/log/apache2/error.log

# osTicket Logs
sudo tail -f /var/www/html/osTicket/logs/errors.log
```

## 🛟 Troubleshooting

### Häufige Probleme
1. **Datenbank nicht erreichbar**
   ```bash
   # Security Group prüfen
   aws ec2 describe-security-groups
   ```

2. **Web-Interface nicht erreichbar**
   ```bash
   # Apache Status
   sudo systemctl status apache2
   ```

### Support
Bei Problemen:
1. Dokumentation konsultieren
2. Issue im Repository erstellen
3. Team kontaktieren:
    - Ronald (Infrastructure): @ronald
    - Milan (Support): @milan