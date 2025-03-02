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

variable "user_data" {
  description = "User data script to install and configure WordPress"
  type        = string
  default     = <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server
systemctl start httpd
systemctl enable httpd
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz --strip-components=1
EOF
}

variable "alb_sg_id" {
  description = "ALB security group ID for allowing traffic"
  type        = string
}
