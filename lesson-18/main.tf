provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_user" "user1" {
  name = "pushkin"

}

variable "aws_users" {
  default = ["Olya", "Lena", "Gena", "Vova", "Donald"]
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}


output "created_iam_users" {
  value = aws_iam_user.users
}
output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id
}
output "created_iam_users_ids_arn" {
  value = [
    for i in aws_iam_user.users :
    "Hello: ${i.name} has ARN: ${i.arn}"
  ]
}


output "created_users_map" {
  value = {
    for i in aws_iam_user.users :
    i.unique_id => i.id
  }
}

output "created_users_if" {
  value = [
    for i in aws_iam_user.users :
    i.name
    if length(i.name) == 4
  ]
}

#-------------------------
resource "aws_instance" "my_lin" {
  count                       = 3
  ami                         = "ami-0ab838eeee7f316eb"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "andrey-fr"
  tags = {
    Name    = "Server number: ${count.index + 1}"
    Project = "Terraform lesson"
  }
}

output "created_servers_all" {
  value = {
    for i in aws_instance.my_lin :
    i.id => i.public_ip
  }
}
