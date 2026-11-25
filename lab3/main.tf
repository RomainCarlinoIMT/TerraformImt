terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_key_pair" "lab_key" {
  key_name   = "terraform-lab-key"
  public_key = file("~/.ssh/terraform-lab-key.pub")
}

resource "aws_security_group" "ssh_access" {
  name        = "lab-ec2-ssh-sg"
  description = "Allow SSH access to EC2 instance"
  vpc_id      = "vpc-01b6138c71cc82aba"

  ingress {
    description = "SSH from anywhere (restrict to your IP /32 in production)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab-ec2-ssh-sg"
  }
}

resource "aws_instance" "web_vm" {
  ami                         = "ami-092c64119783c2f31"
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-0855fbfcf29f845c3"
  vpc_security_group_ids      = [aws_security_group.ssh_access.id]
  key_name                    = aws_key_pair.lab_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "lab-ec2-instance"
  }
}

output "instance_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.web_vm.public_ip
}

output "ssh_command" {
  description = "Commande SSH pour se connecter à la VM"
  value       = "ssh -i ~/.ssh/terraform-lab-key ec2-user@${aws_instance.web_vm.public_ip}"
}