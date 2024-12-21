# osTicket Deployment with AWS

## Overview
This project automates the deployment of an osTicket instance on AWS using Infrastructure as Code (IaC) scripts. It includes setup scripts for MySQL, osTicket, and cleanup tools to remove resources when they are no longer needed.

---

## Features
- **Automated Deployment**: Sets up osTicket and a MySQL database on AWS EC2 instances.
- **AWS Integration**: Utilizes AWS CLI for resource creation and management.
- **Custom Configuration**: Allows user-defined settings for database and osTicket configurations.
- **Cleanup Tools**: Removes all AWS resources created during deployment.

---

## Files and Directories

### **Deployment Scripts**
- **`iac-init.sh`**: Initializes the AWS environment, creates security groups, launches EC2 instances, and sets up osTicket and MySQL.
- **`mysql-setup.sh`**: Configures the MySQL server, creates the database, and prepares it for osTicket.
- **`osticket-setup.sh`**: Installs and configures osTicket, including database connection and web server setup.

### **Cleanup Script**
- **`iac-clean.sh`**: Terminates EC2 instances, deletes security groups, and removes the SSH key pair.

### **Templates and Configurations**
- **`osticket-cloud-init.yml`**: Cloud-init configuration for automating osTicket setup during EC2 instance launch.
- **Terraform Directory**: Contains `main.tf` for defining AWS infrastructure using Terraform (optional).

---

## Prerequisites
1. **AWS Account**: Ensure you have access to an AWS account.
2. **AWS CLI**: Installed and configured on your local machine.
3. **Key Pair**: SSH key pair to access EC2 instances.
4. **Permissions**: IAM user with permissions for EC2, S3, and VPC.

---

## How to Deploy

### 1. Clone the Repository
```bash
git clone https://github.com/your-repository/osTicket-AWS.git
cd osTicket-AWS
```

### 2. Make Scripts Executable
```bash
chmod +x iac-init.sh iac-clean.sh setup/mysql-setup.sh setup/osticket-setup.sh
```

### 3. Run the Deployment Script
Execute the initialization script to deploy resources and set up osTicket:
```bash
./iac-init.sh
```

### 4. Access osTicket
After deployment, the script will provide the public IP address of the osTicket instance. Use this to access osTicket in your browser.

---

## Cleanup Resources
To terminate instances and remove AWS resources, run the cleanup script:
```bash
./iac-clean.sh
```

---

## Customization
- **MySQL Settings**: Update database name, user, and password in `mysql-setup.sh`.
- **osTicket Configuration**: Modify `osticket-setup.sh` to set custom site settings.
- **Terraform**: Use the `terraform` directory for advanced IaC setups.

---

## Troubleshooting
- **Logs**: Check `/var/log/user-data.log` on the EC2 instances for setup errors.
- **AWS CLI Errors**: Ensure the CLI is correctly configured with valid credentials.
- **Permissions**: Verify IAM permissions if resources fail to create.

---

## Contributors
- **Ronald Klauser**
- **Gian Luca Hörler**
- **Milan Fenner**

---

## License
This project is licensed under the MIT License. See `LICENSE.md` for details.

