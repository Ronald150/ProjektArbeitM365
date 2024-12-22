#!/bin/bash

echo "Erstelle VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text)
echo "VPC erstellt: $VPC_ID"

echo "Erstelle Subnetz..."
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text)
echo "Subnet erstellt: $SUBNET_ID"

echo "Erstelle Security Group..."
SG_ID=$(aws ec2 create-security-group --group-name osticket-sg --description "osTicket SG" --vpc-id $VPC_ID --query 'GroupId' --output text)
echo "Security Group erstellt: $SG_ID"

echo "Füge Regeln zur Security Group hinzu..."
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0

echo "Erstelle EC2-Instanz für Webserver..."
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0c02fb55956c7d316 --count 1 --instance-type t2.micro \
    --key-name <dein-key-name> --security-group-ids $SG_ID --subnet-id $SUBNET_ID \
    --user-data file://webserver_setup.sh --query 'Instances[0].InstanceId' --output text)
echo "Webserver-Instanz erstellt: $INSTANCE_ID"

echo "Erstelle MySQL-Datenbank..."
DB_INSTANCE_ID=$(aws rds create-db-instance --db-instance-identifier osticket-db \
    --allocated-storage 20 --db-instance-class db.t2.micro --engine mysql --master-username admin \
    --master-user-password securepassword --vpc-security-group-ids $SG_ID --db-name osticket \
    --query 'DBInstance.DBInstanceIdentifier' --output text)
echo "Datenbank erstellt: $DB_INSTANCE_ID"

echo "Warte auf Ressourcen..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID
aws rds wait db-instance-available --db-instance-identifier osticket-db

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "Webserver erreichbar unter: http://$PUBLIC_IP"

