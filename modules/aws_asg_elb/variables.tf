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
#---------------------------------------------------------------------------
variable "ec2_size" {
  default = {
    "prod"    = "t2.nano"
    "staging" = "t2.nano"
    "dev"     = "t2.micro"
  }
}
#---------------------------------------------------------------------------
variable "vpc_id" {
  default = ""
}
variable "vpc_security_group_ids" {
  default = ""
}
variable "public_subnet_ids" {
  default = []
}
#-------------------------------Autoscaling group---------------------------
variable "min_size" {
  default = "2"
}
variable "max_size" {
  default = "2"
}


