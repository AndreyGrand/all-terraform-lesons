variable "region" {
  description = "Please neter AWS region to deploy server"
  default     = "eu-central-1"
  type        = string
}

variable "instance_type" {
  description = "Enter instance type"
  default     = "t2.micro"
  type        = string
}


variable "allowed_ports" {
  description = "List of ports to open"
  type        = list
  default     = ["80", "443", "22", "8080"]
}

variable "enabled_detailed_monitoring" {
  type    = bool
  default = "false"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map
  default = {
    Owner       = "Andrey G"
    Project     = "Phoenix"
    Costcenter  = "12345"
    Environment = "development"
  }
}
