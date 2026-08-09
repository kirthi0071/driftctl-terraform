# Call VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  vpc_name    = var.vpc_name
  aws_region  = var.aws_region
  common_tags = var.common_tags
  environment = var.environment

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# Call Security Group Module
module "security_group" {
  source = "./modules/security_group"

  vpc_id                     = module.vpc.vpc_id
  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
  common_tags                = var.common_tags
  environment                = var.environment
}

# Call EC2 Module
module "ec2" {
  source = "./modules/ec2"

  instance_type    = var.instance_type
  instance_count   = var.instance_count
  instance_name    = var.instance_name
  enable_public_ip = var.enable_public_ip
  root_volume_size = var.root_volume_size
  common_tags      = var.common_tags
  environment      = var.environment

  # Dependencies from other modules
  public_subnet_id  = module.vpc.public_subnets[0]
  security_group_id = module.security_group.security_group_id
  aws_region        = var.aws_region
}
