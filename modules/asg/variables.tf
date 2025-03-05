variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  description = "Private subnets for ASG instances"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "Target group ARN from the ALB"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for WordPress instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for WordPress"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB security group ID for allowing traffic"
  type        = string
}

variable "bastion_sg" {
  description = "Bastion Host security group ID for allowing traffic"
  type        = string
}

variable "efs_id" {
  description = "EfS id"
  type        = string
}

variable "aws_region" {
  description = "Provider region"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint"
  type        = string
}
variable "db_name" {
  description = "The name of the database for WordPress"
  type        = string
}

variable "db_user" {
  description = "The username for the WordPress database"
  type        = string
}

variable "db_password" {
  description = "The password for the WordPress database"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "RDS endpoint"
  type        = string
}
