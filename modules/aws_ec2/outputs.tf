output "instance_ids" {
  value = ["${aws_instance.instance.*.id}"]
}
output "key_name" {
  description = "List of key names of instances"
  value       = ["${aws_instance.instance.*.key_name}"]
}
output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = ["${aws_instance.instance.*.public_ip}"]
}
output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = ["${aws_instance.instance.*.private_ip}"]
}
output "security_groups" {
  description = "List of associated security groups of instances"
  value       = ["${aws_instance.instance.*.security_groups}"]
}
output "vpc_security_group_ids" {
  description = "List of associated security groups of instances, if running in non-default VPC"
  value       = ["${aws_instance.instance.*.vpc_security_group_ids}"]
}

output "subnet_id" {
  description = "List of IDs of VPC subnets of instances"
  value       = ["${aws_instance.instance.*.subnet_id}"]
}

output "tags" {
  description = "List of tags of instances"
  value       = ["${aws_instance.instance.*.tags}"]
}
