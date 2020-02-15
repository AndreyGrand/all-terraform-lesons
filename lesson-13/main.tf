#----------------------
# Create:
# Security group
# Launch configuration
# Autoscaling group using 2 availability_zones
# Classic load balancer using 2 availability_zones

provider "aws" {
  region = var.region # "eu-central-1"
}


## AMI
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

#*******************
resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First secure group"
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Dynamic secure group" })
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags     = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} IP Address" })
}

resource "aws_instance" "my_webserver" {
  ami                         = data.aws_ami.latest_a_lin.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  #key_name                    = "andrey-fr"
  monitoring             = var.enabled_detailed_monitoring
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  tags                   = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server build by Terraform" })
}
