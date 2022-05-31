#-------------------------------------------------------------------------------
#
#
#
#
#
#
#-------------------------------------------------------------------------------
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}
#-------------------------------------------------------------------------------
resource "aws_launch_configuration" "web" {
  name_prefix     = "${lower(var.name)}-webserver-${lower(var.env)}" #long name with add prefix
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = lookup(var.ec2_size, var.env)
  security_groups = ["${var.vpc_security_group_ids}"]
  user_data       = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}
#-------------------------------------------------------------------------------
resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = var.min_size
  max_size             = var.max_size
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = var.public_subnet_ids
  load_balancers       = [aws_elb.web.name]
  dynamic "tag" {
    for_each = {
      Name          = "${lower(var.name)}-webserver-asg-${lower(var.env)}"
      Environment   = "${var.env}"
      Orchestration = "${var.orchestration}"
      Createdby     = "${var.createdby}"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
#-------------------------------------------------------------------------------
resource "aws_elb" "web" {
  name            = "${lower(var.name)}-web-elb-${lower(var.env)}"
  security_groups = ["${var.vpc_security_group_ids}"]
  subnets         = var.public_subnet_ids

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name          = "${lower(var.name)}-web-elb-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
