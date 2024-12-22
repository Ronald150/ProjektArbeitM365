#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable php7.4
sudo yum install -y httpd php php-cli php-mysqlnd php-imap php-ldap php-xml php-mbstring unzip wget
sudo systemctl start httpd
sudo systemctl enable httpd
wget https://github.com/osTicket/osTicket/releases/download/v1.15.4/osTicket-v1.15.4.zip -P /var/www/html
cd /var/www/html && sudo unzip osTicket-v1.15.4.zip
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

