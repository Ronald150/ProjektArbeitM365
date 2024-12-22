Hier ist die aktualisierte und vollständige **INSTALLATION.md**, die alle Schritte inklusive der Einrichtung von WSL, AWS CLI, Erstellung eines Schlüsselpaares und Klonen des Repositories beschreibt. Die Anweisungen sind ausführlich und enthalten Erklärungen sowie Kommentare.

---

# **INSTALLATION.md**

## **Einleitung**

Diese Anleitung beschreibt die vollständige Einrichtung der Umgebung zur Bereitstellung von osTicket mithilfe von AWS und Infrastruktur als Code (IaC). Die Bereitstellung erfolgt unter Verwendung von WSL (Windows Subsystem for Linux), der AWS CLI und bereitgestellten Bash-Skripten.

---

## **Voraussetzungen**

- Ein aktiver AWS-Account.
- Zugang zum AWS Academy Learner Lab.
- Installierte Software:
  - **Windows Subsystem for Linux (WSL)** mit einer Linux-Distribution (z. B. Ubuntu).
  - **AWS CLI**, um AWS-Dienste zu steuern.
  - **Git**, um das Projekt-Repository zu klonen.

---

## **1. Navigation auf AWS Academy Learner Lab**

### **Schritte zur Navigation im AWS Academy Learner Lab**

1. Melden Sie sich auf der AWS Academy-Plattform an.
2. Navigieren Sie zum Dashboard Ihres Kurses, z. B. "AWS Academy Learner Lab [90559]".

   ![Dashboard](https://github.com/user-attachments/assets/251d7847-3d0f-4fbe-afd8-fe43fb070310)

3. Klicken Sie auf **"Launch AWS Academy Learner Lab"**, um die AWS-Lab-Umgebung zu starten.

   ![Lab starten](https://github.com/user-attachments/assets/24a7b968-0c37-413f-8dd5-be4af12a92a7)

4. Nach dem Start sehen Sie ein Terminal mit einer vorinstallierten AWS CLI.

   ![Lab-Umgebung](https://github.com/user-attachments/assets/5c2a56aa-38e0-48e4-9067-8ec407722722)

---

## **2. Installation und Konfiguration von WSL**

### **Schritt 1: Installation von WSL**
1. Öffnen Sie PowerShell als Administrator.
2. Installieren Sie WSL:
   ```powershell
   wsl --install
   ```
3. Nach der Installation wählen Sie eine Linux-Distribution (z. B. Ubuntu) aus dem Microsoft Store und richten diese ein.

### **Schritt 2: Konfiguration der Linux-Umgebung**
1. Öffnen Sie die WSL-Terminalumgebung.
2. Aktualisieren Sie die Linux-Distribution:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

---

## **3. Installation und Konfiguration von AWS CLI**

### **Schritt 1: Installation der AWS CLI**
1. Laden Sie die AWS CLI herunter und entpacken Sie sie:
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```

2. Überprüfen Sie die Installation:
   ```bash
   aws --version
   ```

### **Schritt 2: Konfiguration der AWS CLI**
1. Führen Sie `aws configure` aus, um die AWS CLI zu konfigurieren:
   ```bash
   aws configure
   ```
   - **AWS Access Key ID**: Geben Sie Ihre AWS Access Key ID ein.
   - **AWS Secret Access Key**: Geben Sie Ihren AWS Secret Access Key ein.
   - **Default region name**: Geben Sie `us-east-1` ein (oder eine andere Region).
   - **Default output format**: Geben Sie `json` ein oder lassen Sie dieses Feld leer.

2. Testen Sie die Konfiguration:
   ```bash
   aws s3 ls
   ```
   Bei erfolgreicher Verbindung wird eine Liste der S3-Buckets angezeigt (sofern vorhanden).

---

## **4. Erstellung eines SSH-Schlüsselpaares und Klonen des Repositories**

### **Schlüsselpaar erstellen**
1. Erstellen Sie ein SSH-Schlüsselpaar:
   ```bash
   ssh-keygen -t rsa -b 4096
   ```
   - Speichern Sie die Schlüssel unter `~/.ssh/id_rsa`.
   - Optional: Legen Sie ein Passwort fest.

2. Fügen Sie den öffentlichen Schlüssel zu GitHub hinzu:
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```
   - Melden Sie sich bei GitHub an, gehen Sie zu **Settings** > **SSH and GPG keys** > **New SSH Key** und fügen Sie den Schlüssel hinzu.
   ![image](https://github.com/user-attachments/assets/fff1868c-9634-4e6e-9ebc-2b02de334ffa)

   ![image](https://github.com/user-attachments/assets/e68bb27a-c8de-4c8f-99c8-52184cfa32a5)

   ![image](https://github.com/user-attachments/assets/7fe759db-222f-4d48-a76a-ce4d8cf9460e)



### **Repository klonen**
1. Klonen Sie das Repository mit SSH:
   ```bash
   git clone git@github.com:Ronald150/ProjektArbeitM365.git
   ```
2. Wechseln Sie in das Verzeichnis:
   ```bash
   cd ProjektArbeitM365
   ```

---

## **5. Deployment von osTicket**

### **Schritt 1: Skripte ausführbar machen**
1. Navigieren Sie in das Projektverzeichnis und machen Sie die Skripte ausführbar:
   ```bash
   chmod +x scripts/*.sh
   ```

### **Schritt 2: Deployment starten**
1. Starten Sie das Deployment:
   ```bash
   ./scripts/iac-init.sh
   ```
   Dieses Skript:
   - Erstellt Sicherheitsgruppen.
   - Startet EC2-Instanzen für MySQL und osTicket.
   - Führt die Einrichtungsskripte aus.

---

## **6. Zugriff auf osTicket**

1. Nach Abschluss des Deployments gibt das Skript die öffentliche IP-Adresse der osTicket-Instanz aus.
2. Öffnen Sie osTicket in Ihrem Browser:
   ```
   http://<public-ip>
   ```
   Ersetzen Sie `<public-ip>` durch die ausgegebene IP-Adresse.

---

## **7. Bereinigung der Ressourcen**

### **Skripte ausführen**
1. Um alle erstellten Ressourcen zu löschen, führen Sie das Bereinigungsskript aus:
   ```bash
   ./scripts/iac-clean.sh
   ```
   Dieses Skript:
   - Beendet und entfernt EC2-Instanzen.
   - Löscht die erstellten Sicherheitsgruppen.
   - Entfernt das SSH-Schlüsselpaar.

---

## **Troubleshooting**

### **Fehlerbehebung**
1. **"Unable to locate credentials"**:
   - Stellen Sie sicher, dass `aws configure` korrekt ausgeführt wurde.

2. **Keine Verbindung zu osTicket**:
   - Überprüfen Sie die Sicherheitsgruppen und Ports (80 und 443).

3. **EC2-Instanz wird nicht gestartet**:
   - Stellen Sie sicher, dass die Region korrekt konfiguriert ist.

4. **Skriptfehler**:
   - Überprüfen Sie die Ausführbarkeit der Skripte:
     ```bash
     chmod +x scripts/*.sh
     ```

---

Diese Installationsanleitung ist vollständig und enthält alle erforderlichen Schritte zur Bereitstellung von osTicket auf AWS.
