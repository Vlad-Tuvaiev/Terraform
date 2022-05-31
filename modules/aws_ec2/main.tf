#------------------------------------------------------------------
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}
#------------------------------------------------------------------
resource "aws_instance" "instance" {

  count                       = var.number_of_instances
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.ec2_size, var.env)
  user_data                   = file("user_data.sh")
  user_data_replace_on_change = var.user_data_replace_on_change
  associate_public_ip_address = var.enable_associate_public_ip_address
  key_name                    = var.key_name
  subnet_id                   = element(var.subnet_id, count.index)
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  monitoring                  = var.monitoring
  iam_instance_profile        = var.iam_instance_profile
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [private_ip, vpc_security_group_ids, root_block_device]
  }
  tags = {
    Name          = "${lower(var.name)}-ec2-${lower(var.env)}-${count.index + 1}"
    Environment   = var.env
    Orchestration = var.orchestration
    Createdby     = var.createdby
  }
  #private_ip           = var.private_ip
}
