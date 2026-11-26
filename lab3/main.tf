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

module "ec2_vm" {
  source = "./ec2_ssh_instance"

  name          = "lab-ec2-vm"
  instance_type = "t2.micro"
}