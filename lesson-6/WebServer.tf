#------------
#My Terraform
#
#Build WebServer during bootstrap
#
# made by me

provider "aws" {
  region = "eu-central-1"
}
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id

}

resource "aws_instance" "my_webserver" {
  ami                         = "ami-0ab838eeee7f316eb" #Amazone linux AMI
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "My Web server"
    Owner   = "Andrey"
    Project = "Terraform lesson 2"
  }
  vpc_security_group_ids = [aws_security_group.my_webserver.id] #sg-0d936b3a22eb92f70 my lin
  user_data = templatefile("./user_data.sh.tpl", { f_name = "Andrey", l_name = "Gerankin",
    names = ["Vasia", "Ola", "Petya", "Kolya", "Boris", "Helen"]
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First secure group"
  #vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # add your IP address here
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # add your IP address here
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # add your IP address here
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow SSH, HTTP and HTTPS"
  }
}
