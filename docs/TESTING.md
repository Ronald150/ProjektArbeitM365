# 🧪 Testdokumentation osTicket AWS
*Verantwortlich: Milan*

## 📋 Inhaltsverzeichnis
- [1. Testübersicht](#1-testübersicht)
- [2. Testumgebung](#2-testumgebung)
- [3. Testfälle](#3-testfälle)
- [4. Testprotokolle](#4-testprotokolle)
- [5. Performance Tests](#5-performance-tests)
- [6. Sicherheitstests](#6-sicherheitstests)
- [7. Automatisierte Tests](#7-automatisierte-tests)
- [8. Fehlerbehebung](#8-fehlerbehebung)
- [9. Testabnahme](#9-testabnahme)

## 1. Testübersicht

### 1.1 Testabdeckung
| Bereich | Tests | Status | Verantwortlich |
|---------|--------|--------|----------------|
| Infrastructure | 15 | ✅ | Ronald |
| Frontend | 20 | ✅ | Milan |
| Backend | 25 | ✅ | Milan |
| Security | 18 | ✅ | Gian Luca |
| Integration | 12 | ✅ | Team |

### 1.2 Testmatrix
| Priorität | Anzahl Tests | Bestanden | Fehlgeschlagen |
|-----------|--------------|-----------|----------------|
| Kritisch | 25 | 25 | 0 |
| Hoch | 35 | 34 | 1 |
| Mittel | 20 | 20 | 0 |
| Niedrig | 10 | 9 | 1 |

## 2. Testumgebung

### 2.1 Infrastruktur-Setup
```bash
# Testumgebung erstellen
terraform workspace new test
terraform apply -var-file="test.tfvars"

# Umgebungsvariablen
export TEST_ENV="test"
export TEST_DB="osticket_test"
```

### 2.2 Testdaten
```sql
-- Testdaten generieren
INSERT INTO ost_user (name, email) VALUES
('Test User 1', 'test1@example.com'),
('Test User 2', 'test2@example.com');

-- Ticket Testdaten
INSERT INTO ost_ticket (user_id, subject) VALUES
(1, 'Test Ticket 1'),
(2, 'Test Ticket 2');
```

## 3. Testfälle

### 3.1 Infrastructure Tests (A4)

#### Test INF-001: AWS Deployment
- **Beschreibung**: Vollständiges Deployment der AWS-Infrastruktur
- **Vorbedingung**: Terraform konfiguriert
- **Testschritte**:
   1. `terraform init`
   2. `terraform plan`
   3. `terraform apply`
- **Erwartetes Ergebnis**: Alle Ressourcen erstellt
- **Tatsächliches Ergebnis**: [SCREENSHOT_1]
- **Status**: ✅ Erfolgreich
- **Getestet von**: Ronald
- **Datum**: [DATUM]

#### Test INF-002: Netzwerk-Konnektivität
- **Beschreibung**: Überprüfung der Netzwerkverbindungen
- **Testschritte**:
  ```bash
  # VPC Test
  aws ec2 describe-vpcs
  
  # Subnet Test
  aws ec2 describe-subnets
  
  # Security Group Test
  aws ec2 describe-security-groups
  ```
- **Screenshot**: [SCREENSHOT_2]
- **Status**: ✅ Erfolgreich

### 3.2 Frontend Tests (A4)

#### Test FE-001: Login System
- **Beschreibung**: Test des Login-Systems
- **Testschritte**:
   1. Aufruf der Login-Seite
   2. Eingabe Testbenutzer
   3. Überprüfung Redirect
- **Screenshot**: [SCREENSHOT_3]
- **Status**: ✅ Erfolgreich

#### Test FE-002: Ticket Erstellung
- **Testschritte**:
   1. Login als Benutzer
   2. "Neues Ticket" auswählen
   3. Formular ausfüllen
   4. Absenden
- **Screenshot**: [SCREENSHOT_4]
- **Status**: ✅ Erfolgreich

### 3.3 Backend Tests (A4)

#### Test BE-001: Datenbank-Verbindung
```php
# Test-Code
$mysqli = new mysqli($host, $user, $pass, $db);
if ($mysqli->connect_error) {
    die('Connect Error');
}
echo "Connected successfully";
```
- **Screenshot**: [SCREENSHOT_5]
- **Status**: ✅ Erfolgreich

#### Test BE-002: API Endpoints
```bash
# API Tests
curl -X POST http://api/tickets \
  -H "Content-Type: application/json" \
  -d '{"subject":"Test Ticket","description":"Test"}'
```
- **Screenshot**: [SCREENSHOT_6]
- **Status**: ✅ Erfolgreich

## 4. Testprotokolle

### 4.1 Automatisierte Tests
```bash
# Test Suite ausführen
./run_test_suite.sh

# Ergebnisse
Total Tests: 90
Passed: 88
Failed: 2
Success Rate: 97.8%
```

### 4.2 Manuelle Tests
| Test ID | Tester | Datum | Status | Screenshot |
|---------|--------|-------|---------|------------|
| MAN-001 | Milan | [DATUM] | ✅ | [SCREENSHOT_7] |
| MAN-002 | Milan | [DATUM] | ✅ | [SCREENSHOT_8] |

## 5. Performance Tests

### 5.1 Last-Tests
```bash
# Apache Benchmark
ab -n 1000 -c 10 http://osticket/
```
- **Ergebnisse**:
   - Requests per second: 234.56
   - Time per request: 42.63ms
   - Failed requests: 0
- **Screenshot**: [SCREENSHOT_9]

### 5.2 Stress-Tests
```bash
# Stress Test Script
./stress_test.sh -u 100 -d 300
```
- **Screenshot**: [SCREENSHOT_10]

## 6. Sicherheitstests

### 6.1 Penetrationstests
```bash
# Security Scan
nmap -sV --script vulners osticket.example.com
```
- **Screenshot**: [SCREENSHOT_11]

### 6.2 SSL Tests
```bash
# SSL Check
ssllabs-scan osticket.example.com
```
- **Screenshot**: [SCREENSHOT_12]

## 7. Automatisierte Tests

### 7.1 CI/CD Pipeline Tests
```yaml
# GitHub Actions
name: Test Suite
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Tests
        run: |
          ./run_integration_tests.sh
          ./run_unit_tests.sh
```

### 7.2 Smoke Tests
```bash
# Deployment Verification
./verify_deployment.sh
```
- **Screenshot**: [SCREENSHOT_13]

## 8. Fehlerbehebung

### 8.1 Bekannte Probleme
| Problem | Lösung | Status |
|---------|--------|--------|
| DB Timeout | Connection Pool angepasst | ✅ |
| Memory Limit | PHP Memory erhöht | ✅ |

### 8.2 Debugging
```php
// Debug Logging
error_reporting(E_ALL);
ini_set('display_errors', 1);
```

## 9. Testabnahme

### 9.1 Abnahmekriterien
- [x] Alle kritischen Tests bestanden
- [x] Performance-Ziele erreicht
- [x] Sicherheitsaudit bestanden
- [x] Dokumentation vollständig

### 9.2 Sign-off
| Name | Rolle | Datum | Unterschrift |
|------|-------|-------|-------------|
| Milan | Test Lead | [DATUM] | ________ |
| Ronald | Infrastructure | [DATUM] | ________ |
| Gian Luca | Security | [DATUM] | ________ |

## Anhang

### A. Testumgebungen
| Umgebung | URL | Status |
|----------|-----|--------|
| Development | dev.osticket.local | ✅ |
| Staging | staging.osticket.local | ✅ |
| Production | osticket.example.com | ✅ |

### B. Test Tools
- JMeter für Performance Tests
- Selenium für UI Tests
- PHPUnit für Unit Tests
- Postman für API Tests

### C. Testkonfigurationen
```ini
[TEST_CONFIG]
base_url = http://test.osticket.local
admin_user = test_admin
admin_pass = test_pass_123
```

### D. Testdaten-Backup
```bash
# Backup Testdaten
mysqldump -u test_user -p test_db > test_backup.sql
```