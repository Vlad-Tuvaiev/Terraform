provider "aws" {
  region = "us-east-1"
}

module "vpc_dev" {
  source               = "../modules/aws_vpc"
  env                  = "dev"
  vpc_cidr             = "10.100.0.0/16"
  public_subnets_cidr  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnets_cidr = []
  db_subnets_cidr      = []
}

module "key" {
  source = "../modules/aws_key_pair"
}

module "ec2" {
  source                 = "../modules/aws_ec2"
  number_of_instances    = "1"
  key_name               = module.key.key_name_local
  env                    = "dev"
  vpc_security_group_ids = module.vpc_dev.security_group_id
  subnet_id              = module.vpc_dev.public_subnets_ids
  depends_on = [
    module.key
  ]
}

# module "asg_elb-dev" {
#   source                 = "../modules/aws_asg_elb"
#   env                    = "dev"
#   vpc_id                 = module.vpc_dev.vpc_id
#   vpc_security_group_ids = module.vpc_dev.security_group_id
#   public_subnet_ids      = module.vpc_dev.public_subnets_ids
#   depends_on = [
#     module.vpc_dev
#   ]
# }

#-------------------------------------------------------------------------------
# output "Web_load_balancer" {
#   value = module.asg_elb-dev.Web_load_balancer_url
# }
