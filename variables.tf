variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
  default     = "my-key"
}

variable "ami_id" {
  description = "AMI ID for the WordPress EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for WordPress servers"
  type        = string
  default     = "t3.micro"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  description = "RDS MySQL password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  default = "wordpressdb"
}

variable "domain_name" {
  description = "Domain name to use in Route53"
  type        = string
  default     = "gbenga.online"
}
