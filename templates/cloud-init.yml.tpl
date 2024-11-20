#cloud-config
package_update: true
package_upgrade: true

packages:
  - apache2
  - php
  - php-mysql
  - php-imap
  - php-xml
  - mysql-client
  - unzip
  - curl
  - certbot
  - python3-certbot-apache

write_files:
  - path: /tmp/install_osticket.sh
    permissions: '0755'
    content: |
      #!/bin/bash
      # Installation Script by Ronald

      # Download and install osTicket
      wget https://github.com/osTicket/osTicket/releases/download/v1.17.3/osTicket-v1.17.3.zip
      unzip osTicket-v1.17.3.zip -d /var/www/html/

      # Configure osTicket
      cp /var/www/html/osTicket/include/ost-sampleconfig.php /var/www/html/osTicket/include/ost-config.php
      chmod 0666 /var/www/html/osTicket/include/ost-config.php

      # Database configuration
      sed -i "s/DB_HOST/${db_host}/g" /var/www/html/osTicket/include/ost-config.php
      sed -i "s/DB_NAME/${db_name}/g" /var/www/html/osTicket/include/ost-config.php
      sed -i "s/DB_USER/${db_user}/g" /var/www/html/osTicket/include/ost-config.php
      sed -i "s/DB_PASS/${db_password}/g" /var/www/html/osTicket/include/ost-config.php

      # Security headers (aligned with Gian Lucas security requirements)
      cat >> /etc/apache2/conf-available/security.conf << EOF
      Header set X-Content-Type-Options nosniff
      Header set X-Frame-Options SAMEORIGIN
      Header set X-XSS-Protection "1; mode=block"
      Header set Content-Security-Policy "default-src 'self'"
      EOF

      # Enable Apache modules and configurations
      a2enmod headers
      a2enmod ssl
      a2enconf security

      # Restart Apache
      systemctl restart apache2

  - path: /usr/local/bin/backup_script.sh
    permissions: '0755'
    content: |
      #!/bin/bash
      # Backup Script (coordinated with Gian Lucas backup strategy)

      # Database backup
      mysqldump -h ${db_host} -u ${db_user} -p${db_password} ${db_name} > /tmp/osticket_backup.sql

      # Upload to S3
      aws s3 cp /tmp/osticket_backup.sql s3://osticket-backups-${environment}/db/
      aws s3 sync /var/www/html/osTicket/attachments s3://osticket-backups-${environment}/attachments/

      # Cleanup
      rm /tmp/osticket_backup.sql

runcmd:
  - bash /tmp/install_osticket.sh
  - systemctl enable apache2
  - systemctl start apache2

  # Setup CloudWatch Agent (für Gian Lucas Monitoring)
  - wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
  - dpkg -i amazon-cloudwatch-agent.deb
  - /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:/AmazonCloudWatch/osticket

# Setup cron jobs
cron:
  - name: "database backup"
    user: root
    special: "@daily"
    cmd: /usr/local/bin/backup_script.sh