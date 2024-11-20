# 🔄 CI/CD Pipeline
*Verantwortlich: Gian Luca*

## GitHub Actions Workflow
```yaml
name: osTicket CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
        
      - name: Terraform Format
        run: terraform fmt -check
        
      - name: Terraform Init
        run: terraform init
        
      - name: Terraform Validate
        run: terraform validate
        
      - name: Run Security Scans
        run: |
          ./security/scan.sh
          
  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        
      - name: Deploy to AWS
        run: |
          terraform apply -auto-approve
```