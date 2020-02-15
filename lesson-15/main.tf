provider "aws" {
  region = "eu-central-1"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}


resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }
  depends_on = [null_resource.command1]
}
resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "print('Hello world')"
    interpreter = ["python", "-c"]
  }
}
resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Vasya"
      NAME2 = "Kolya"
      NAME3 = "Petya"
    }
  }
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
  provisioner "local-exec" {
    command = "echo Hello from AWS Instance Creation"
  }
}

resource "null_resource" "command6" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }
  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.my_ubuntu]
}
