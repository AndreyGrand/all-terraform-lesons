provider "aws" {
  region = "eu-central-1"
  #  alias  = "Germany"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "Irland"
}
provider "aws" {
  region = "us-east-1"
  alias  = "USA"
}
#####################
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_instance" "my_default_server" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name    = "Server Germany"
    Project = "Terraform lesson"
  }
}
data "aws_ami" "latest_ubuntu_usa" {
  provider    = aws.USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_instance" "my_usa_server" {
  provider                    = aws.USA
  ami                         = data.aws_ami.latest_ubuntu_usa.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name    = "Server USA"
    Project = "Terraform lesson"
  }
}
data "aws_ami" "latest_ubuntu_irl" {
  provider    = aws.Irland
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_instance" "my_irland_server" {
  provider                    = aws.Irland
  ami                         = data.aws_ami.latest_ubuntu_irl.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name    = "Server Ireland"
    Project = "Terraform lesson"
  }
}
