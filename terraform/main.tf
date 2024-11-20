# Hauptverantwortlich: Ronald
# Infrastructure as Code für AWS osTicket System

provider "aws" {
  region = var.aws_region
}

# VPC Konfiguration
resource "aws_vpc" "ticket_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ticket-system-vpc"
    Environment = var.environment
    ManagedBy = "Ronald"
  }
}

# Weitere VPC Komponenten...

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.ticket_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ticket-system-public"
    Environment = var.environment
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.ticket_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "ticket-system-private"
    Environment = var.environment
  }
}

# Security Groups definieren
resource "aws_security_group" "web" {
  name        = "web_sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.ticket_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
    Environment = var.environment
  }
}

# Database Security Group
resource "aws_security_group" "db" {
  name        = "db_sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.ticket_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  tags = {
    Name = "db-sg"
    Environment = var.environment
  }
}

# RDS Instance
resource "aws_db_instance" "osticket" {
  identifier           = "osticket-${var.environment}"
  allocated_storage    = 20
  storage_type         = "gp3"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.default.id

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  tags = {
    Name = "osticket-db"
    Environment = var.environment
    ManagedBy = "Ronald"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name      = var.key_name

  user_data = templatefile("${path.module}/templates/cloud-init.yml.tpl", {
    db_host     = aws_db_instance.osticket.endpoint
    db_name     = var.db_name
    db_user     = var.db_username
    db_password = var.db_password
    environment = var.environment
  })

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "osticket-web"
    Environment = var.environment
    ManagedBy = "Ronald"
  }

  monitoring = true # Für Gian Lucas CloudWatch Monitoring

  depends_on = [aws_db_instance.osticket]
}

# CloudWatch Alarms (für Gian Lucas Monitoring)
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period             = "120"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "This metric monitors EC2 CPU utilization"
  alarm_actions      = [var.sns_topic_arn]

  dimensions = {
    InstanceId = aws_instance.web.id
  }
}

# S3 Bucket für Backups (für Gian Lucas Backup-Strategie)
resource "aws_s3_bucket" "backups" {
  bucket = "osticket-backups-${var.environment}"

  tags = {
    Name = "osticket-backups"
    Environment = var.environment
    ManagedBy = "Gian Luca"
  }
}

# Outputs
output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.osticket.endpoint
}