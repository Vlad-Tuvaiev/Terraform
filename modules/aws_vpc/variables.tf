#---------------------COMMON VARIABLES--------------------------------------
variable "name" {
  description = "Name to be used on all resources as prefix"
  default     = "Project1"
}
variable "env" {
  description = "Environment for service"
  default     = "dev"
}
variable "orchestration" {
  description = "Type of orchestration"
  default     = "Terraform"
}
variable "createdby" {
  description = "Created by"
  default     = "Vlad Tuvaiev"
}
#----------------------------------------------------------------------------
variable "allow_port_list" {
  description = "Allowed ports from/to host"
  default = {
    "prod"    = ["80", "443"]
    "staging" = ["80", "443", "8080"]
    "dev"     = ["80", "443", "8080", "22"]
  }
}
#----------------------------------------------------------------------------
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnets_cidr" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}
variable "private_subnets_cidr" {
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24",
  ]
}
variable "db_subnets_cidr" {
  default = [
    "10.0.21.0/24",
    "10.0.22.0/24",
  ]
}



