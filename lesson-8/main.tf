provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

data "aws_region" "current" {}

output "data_region_name" {
  value = data.aws_region.current.name
}

output "data_region_description" {
  value = data.aws_region.current.description
}

data "aws_availability_zones" "working" {
  state = "available"
}

output "data_availability_zones" {
  value = data.aws_availability_zones.working.names
}

data "aws_vpcs" "my_vpcs" {
}
output "data_aws_vpcs_my_vpcs_ids" {
  value = data.aws_vpcs.my_vpcs.ids
}



data "aws_vpc" "vpc_prod" {
  tags = {
    Name = "Prod"
  }
}
output "data_aws_vpc_vpc_prod_id" {
  value = data.aws_vpc.vpc_prod.id
}
output "data_aws_vpc_vpc_prod_cidr" {
  value = data.aws_vpc.vpc_prod.cidr_block
}

resource "aws_subnet" "subnet_prod_1" {
  vpc_id            = data.aws_vpc.vpc_prod.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.10.1.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Account is ${data.aws_caller_identity.current.account_id}"
    Gegion  = data.aws_region.current.description
  }

}
resource "aws_subnet" "subnet_prod_2" {
  vpc_id            = data.aws_vpc.vpc_prod.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.10.2.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Account is ${data.aws_caller_identity.current.account_id}"
    Gegion  = data.aws_region.current.description
  }

}
