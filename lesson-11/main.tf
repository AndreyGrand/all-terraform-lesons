provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}
output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

data "aws_ami" "latest_a_lin" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.0-x86_64-gp2"]
  }
}

output "latest_a_lin_ami_id" {
  value = data.aws_ami.latest_a_lin.id
}
output "latest_a_lin_ami_name" {
  value = data.aws_ami.latest_a_lin.name
}

data "aws_ami" "latest_win" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

output "latest_win_ami_id" {
  value = data.aws_ami.latest_win.id
}
output "latest_win_ami_name" {
  value = data.aws_ami.latest_win.name
}


resource "aws_instance" "my_latest_ubuntu" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "My Ubuntu server"
    Owner   = "Andrey"
    Project = "Terraform lesson"
  }

}


resource "aws_instance" "my_lin" {
  ami                         = data.aws_ami.latest_a_lin.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "My Amazon Linux server"
    Owner   = "Andrey"
    Project = "Terraform lesson"
  }
}

resource "aws_instance" "my_win" {
  ami                         = data.aws_ami.latest_win.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "My Windows server"
    Owner   = "Andrey"
    Project = "Terraform lesson"
  }
}
