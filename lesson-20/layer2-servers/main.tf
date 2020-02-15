provider "aws" {
  region = "eu-central-1"
}
terraform {
  backend "s3" {
    bucket = "gerankin-project-kgb-terraform-state"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-central-1"
  }
}

#++===============================

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "gerankin-project-kgb-terraform-state"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"

  }
}
## AMI
data "aws_ami" "latest_amazon_lin" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.0-x86_64-gp2"]
  }
}
#================================================

resource "aws_instance" "web-server" {
  ami                         = data.aws_ami.latest_amazon_lin.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  #key_name                    = "andrey-fr"

  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  user_data              = <<EOF
#!/bin/bash
echo "------------START ------------"
yum -y update
yum -y install httpd
PrivateIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html><body bgcolor=black><center><h2><p><font color=red>Hello 4uvaki from $PrivateIP on  $(date)</p></h2></center></body></html>" > /var/www/html/index.html
service httpd start
chkconfig httpd on
echo "UserData executed on $(date)" >> /var/www/html/log.txt
echo "------------FINISH ------------"
EOF

  tags = {
    Name = "WebServer"
  }
}





resource "aws_security_group" "webserver" {
  name   = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "web-server-sg"
    Owner = "Andrey G"
  }
}
#=========================================
output "network_details" {
  value = data.terraform_remote_state.network
}
output "webserver_sg_id" {
  value = aws_security_group.webserver.id
}
output "web_server_public_ip" {
  value = aws_instance.web-server.public_ip
}
