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
