provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "mysql_instance" {
  ami           = "ami-08c40ec9ead489470" # Beispiel-AMI für Ubuntu
  instance_type = "t2.micro"
  key_name      = "osTicketKey" # Ersetzen Sie dies mit dem tatsächlichen Schlüsselpaar-Namen

  tags = {
    Name = "MySQLInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y mysql-server
              EOF

  security_groups = [aws_security_group.mysql_sg.name]
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg"
  description = "Ermöglicht Zugriff auf MySQL und SSH"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ersetzen Sie durch spezifische IP-Bereiche für mehr Sicherheit
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ersetzen Sie durch spezifische IP-Bereiche für mehr Sicherheit
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "mysql_instance" {
  ami           = "ami-08c40ec9ead489470" # Beispiel-AMI für Ubuntu
  instance_type = "t2.micro"
  key_name      = "osTicketKey" # Ersetzen Sie dies mit dem tatsächlichen Schlüsselpaar-Namen

  tags = {
    Name = "MySQLInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y mysql-server
              EOF

  security_groups = [aws_security_group.mysql_sg.name]
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg"
  description = "Ermöglicht Zugriff auf MySQL und SSH"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ersetzen Sie durch spezifische IP-Bereiche für mehr Sicherheit
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ersetzen Sie durch spezifische IP-Bereiche für mehr Sicherheit
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "mysql_instance" {
  ami           = "ami-08c40ec9ead489470" # Beispiel-AMI für Ubuntu
  instance_type = "t2.micro"
  key_name      = "osTicketKey" # Ersetzen Sie dies mit dem tatsächlichen Schlüsselpaar-Namen

  tags = {
    Name = "MySQLInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y mysql-server
              EOF

  security_groups = [aws_security_group.mysql_sg.name]
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg"
  description = "Ermöglicht Zugriff auf MySQL und SSH"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ersetzen Sie durch spezifische IP-Bereiche für mehr Sicherheit
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ersetzen Sie durch spezifische IP-Bereiche für mehr Sicherheit
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
