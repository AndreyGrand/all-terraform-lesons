provider "aws" {
  region = "eu-north-1"
}
terraform {
  backend "s3" {
    bucket = "gerankin-project-kgb-terraform-state"
    key    = "globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

#======================
output "company_name" {
  value = "My Home Corp"
}

output "owner" {
  value = "Andrey G"
}

output "tags" {
  value = {
    Project    = "Home terraform learning"
    CostCenter = "R&D"
    Country    = "Russia"
  }


}
