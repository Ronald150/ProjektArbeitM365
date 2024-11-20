# Cloud Ticket System - osTicket auf AWS 🎫

## 📋 Inhaltsverzeichnis
- [Übersicht](#übersicht)
- [Team](#team)
- [Technologie-Stack](#technologie-stack)
- [Kosten](#kosten)
- [Schnellstart](#schnellstart)
- [Dokumentation](#dokumentation)
- [Repository-Struktur](#repository-struktur)

## 🔍 Übersicht
Dieses Projekt implementiert ein vollautomatisiertes osTicket-System auf AWS mittels Infrastructure as Code (IaC) und Cloud-Init.

## 👥 Team
| Name | Rolle | Verantwortlichkeiten |
|------|-------|---------------------|
| Ronald | Infrastructure & AWS | IaC, Cloud-Architektur |
| Milan | Dokumentation & Testing | Docs, QA |

## 🛠 Technologie-Stack
| Komponente | Version | Beschreibung |
|------------|---------|--------------|
| Terraform | 1.5+ | Infrastructure as Code |
| AWS | - | Cloud Provider |
| osTicket | v1.17.3 | Ticketing System |
| MySQL | 8.0 | Datenbank |
| MySQL Workbench | 8.0 | DBMS |

## 💰 Kosten
### Monatliche Kosten
| Service | Kosten/Monat | Details |
|---------|--------------|----------|
| EC2 (t2.micro) | ~$8.50 | Web Server |
| RDS (t3.micro) | ~$15.00 | Datenbank |
| **Gesamt** | **~$25.00** | |

### Vergleich mit Alternativen
| System | Kosten/Agent/Monat | Vorteile | Nachteile |
|--------|-------------------|-----------|------------|
| Zendesk | $49 | SaaS, Support | Teuer |
| JIRA | $20 | Features | Komplex |
| osTicket | $0 | Kostenlos, Anpassbar | Self-Hosting |

## 🚀 Schnellstart
```bash
# 1. Repository klonen
git clone <repository-url>
cd ticket-system

# 2. Terraform initialisieren
terraform init

# 3. Variablen konfigurieren
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars

# 4. Deployment starten
terraform apply
```

## 📚 Dokumentation
- [Installation Guide](docs/INSTALLATION.md)
- [Testing](docs/TESTING.md)
- [Architektur](docs/ARCHITECTURE.md)
- [Wartung](docs/MAINTENANCE.md)
- [Reflexion](docs/REFLECTION.md)

## 📂 Repository-Struktur
```
.
├── 📄 README.md
├── 📁 terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── 📁 scripts/
│   └── cloud-init.yml
└── 📁 docs/
    ├── INSTALLATION.md
    ├── TESTING.md
    ├── ARCHITECTURE.md
    ├── MAINTENANCE.md
    └── REFLECTION.md
```
