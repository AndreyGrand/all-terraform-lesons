#autofill parameters for dev
#file can be name
# terraform.tfvars
# *.auto.tfvars
region                      = "ca-central-1"
instance_type               = "t3.small"
enabled_detailed_monitoring = false
allowed_ports               = ["443", "22", "8080"]
common_tags = {
  Owner       = "Andrey G"
  Project     = "Phoenix"
  Costcenter  = "12345"
  Environment = "PROD"
}
