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
#User data must be in work folder or change in module. user.data.sh
#---------------------------------------------------------------------------
variable "number_of_instances" {
  description = "Number of instances to make"
  default     = "1"
}
variable "key_name" {
  description = "Path to Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = ""
}
variable "ec2_size" {
  description = "type of ec2 instance depend of enviroment"
  default = {
    "prod"    = "t2.nano"
    "staging" = "t2.nano"
    "dev"     = "t2.micro"
  }
}
variable "user_data_replace_on_change" {
  description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true. Defaults to false if not set."
  type        = bool
  default     = true
}
variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}
#---------------------------------------------------------------------------
variable "enable_associate_public_ip_address" {
  description = "Enabling associate public ip address (Associate a public ip address with an instance in a VPC)"
  default     = "true"
}
variable "vpc_security_group_ids" {
  description = "ID of security group for instance"
}
variable "subnet_id" {
  default = [""]
}
variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  default     = ""
}
#---------------------------------------------------------------------------
variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  default     = ""
}
#---------------------------------------------------------------------------
