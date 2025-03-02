provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets= var.private_subnets
  azs            = var.azs
}

module "bastion" {
  source         = "./modules/bastion"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets_ids
  key_name       = var.key_name
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets_ids
}

module "asg" {
  source                = "./modules/asg"
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets_ids
  alb_target_group_arn  = module.alb.target_group_arn
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  alb_sg_id             = module.alb.alb_sg_id
}

module "rds" {
  source            = "./modules/rds"
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets_ids
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = var.db_name
  wordpress_sg_id   = module.asg.wordpress_sg_id
}

module "efs" {
  source             = "./modules/efs"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets_ids
  vpc_cidr           = var.vpc_cidr
}

module "route53" {
  source      = "./modules/route53"
  domain_name = var.domain_name
  alb_dns_name= module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
}
