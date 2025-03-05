variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  description = "List of private subnets for RDS"
  type        = list(string)
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "wordpress_sg_id" {
  description = "WordPress instances security group ID for DB access"
  type        = string
}
