
#----------------------
# Create:
# Security group
# Launch configuration
# Autoscaling group using 2 availability_zones
# Classic load balancer using 2 availability_zones

provider "aws" {
  region = "eu-west-2"
}
## availability_zone
data "aws_availability_zones" "working" {
  state = "available"
}
output "data_availability_zones" {
  value = data.aws_availability_zones.working.names
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
    for_each = ["80", "443"]
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

  tags = {
    Name = "Dynamic secure group"
  }
}

resource "aws_launch_configuration" "web" {
  //name            = "WebServer-Highly-available-LC"
  name_prefix     = "WebServer-Highly-available-LC-"
  image_id        = data.aws_ami.latest_a_lin.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my_webserver.id]
  user_data       = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name   = "Webserver-in-ASG"
      Owner  = "Andrey G"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = "tag.key"
      value               = "tag.value"
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.working.names[0], data.aws_availability_zones.working.names[1]]
  security_groups    = [aws_security_group.my_webserver.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "WebServer-Highly-Available-ELB"
  }
}
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}
#-------------------
output "web_load_balancer_url" {
  value = aws_elb.web.dns_name
}
