variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EFS mount targets"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC for security group ingress"
  type        = string
}

variable "wordpress_sg_id" {
  description = "WordPress instances security group ID for DB access"
  type        = string
}

variable "bastion_sg" {
  description = "Bastion Host SG"
  type        = string
}

