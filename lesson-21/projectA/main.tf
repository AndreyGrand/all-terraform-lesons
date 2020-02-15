provider "aws" {
  region = "eu-north-1"
}
terraform {
  backend "s3" {
    bucket = "gerankin-project-kgb-terraform-state"
    key    = "dev/lesson-21-2/terraform.tfstate"
    region = "eu-central-1"
  }
}
/*
module "vpc-default" {
  source = "../modules/aws_network"
}
*/
module "vpc-dev" {
  //source               = "../modules/aws_network"
  source               = "github.com/AndreyGrand/my-terraform-lessons.git//aws_network"
  env                  = "dev"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = []
}
/*
module "vpc-prod" {
  source               = "../modules/aws_network"
  env                  = "production"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24", "10.100.33.0/24"]
}
*/
module "vpc-test" {
  source               = "github.com/AndreyGrand/my-terraform-lessons.git//aws_network"
  env                  = "staging"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24"]
}
#================
output "prod_public_subnet_ids" {
  value = module.vpc-dev.public_subnet_ids
}
output "prod_private_subnet_ids" {
  value = module.vpc-dev.private_subnet_ids
}

output "dev_public_subnet_ids" {
  value = module.vpc-test.public_subnet_ids
}
output "dev_private_subnet_ids" {
  value = module.vpc-test.private_subnet_ids
}
