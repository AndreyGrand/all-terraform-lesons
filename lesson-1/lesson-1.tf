provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_ubuntu" {
  ami                         = "ami-0cc0a36f626a4fdf5"
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
  ami                         = "ami-0ab838eeee7f316eb"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "My Amazon Linux server"
    Owner   = "Andrey"
    Project = "Terraform lesson"
  }
}
