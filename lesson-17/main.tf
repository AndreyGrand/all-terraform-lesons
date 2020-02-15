provider "aws" {
  region = "eu-central-1"
}

variable "env" {
  default = "prod"
}
variable "prod_owner" {
  default = "Andrey G"
}
variable "non_prod_owner" {
  default = "Dyadya Vasya"
}
variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
    "staging" = "t3.small"
  }
}

resource "aws_instance" "my_lin" {
  ami                         = "ami-0ab838eeee7f316eb"
  instance_type               = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "${var.env} server"
    Owner   = var.env == "prod" ? var.prod_owner : var.non_prod_owner
    Project = "Terraform lesson"
  }
}

resource "aws_instance" "my_lin_2" {
  ami                         = "ami-0ab838eeee7f316eb"
  instance_type               = lookup(var.ec2_size, var.env)
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "${var.env} Second server"
    Owner   = var.env == "prod" ? var.prod_owner : var.non_prod_owner
    Project = "Terraform lesson"
  }
}
resource "aws_instance" "my_dev_bastion" {
  count                       = var.env == "dev" ? 1 : 0
  ami                         = "ami-0ab838eeee7f316eb"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "Bastion for dev server"
    Project = "Terraform lesson"
  }
}
variable "allowed_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080"]
  }
}
resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First secure group"
  dynamic "ingress" {
    for_each = lookup(var.allowed_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dynamic secure group"
  }
}
