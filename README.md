# Terraform Capstone Project: Automated WordPress Deployment on AWS

## Project Scenario

**DigitalBoost**, a digital marketing agency, aims to elevate its online presence by launching a high-performance WordPress website for their clients. As an AWS Solutions Architect, your task is to design and implement a scalable, secure, and cost-effective WordPress solution using various AWS services. Automation through Terraform will be key to achieving a streamlined and reproducible deployment process.

---

## Prerequisites

Before proceeding, ensure you have the following:

- AWS CLI configured with appropriate credentials
- Terraform installed on your local machine
- Basic knowledge of Terraform and AWS infrastructure

---

## Project Overview

This project involves deploying a **scalable WordPress site** using Terraform. The key AWS components include:

- **VPC (Virtual Private Cloud)** with public and private subnets
- **NAT Gateway** for private subnet internet access
- **Amazon RDS MySQL** database for WordPress
- **Amazon EFS** for shared file storage
- **Application Load Balancer** for traffic distribution
- **Auto Scaling Group** for high availability and fault tolerance

---

## Infrastructure Setup

### 1. VPC Setup

#### Objective

- Create a **VPC** to isolate and secure WordPress infrastructure.
- Define **IP address ranges** for the VPC.
- Create **public and private subnets**.
- Configure **route tables** for each subnet.

#### Terraform Implementation

```hcl
resource "aws_vpc" "wordpress_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}
```

### 2. Public and Private Subnets with NAT Gateway

#### Objective

- Implement a **secure network** with public and private subnets.
- Use a **NAT Gateway** to allow internet access from the private subnet.

#### Terraform Implementation

```hcl
resource "aws_nat_gateway" "wordpress_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}
```

### 3. AWS MySQL RDS Setup

#### Objective

- Deploy a **managed MySQL database** using Amazon RDS.
- Configure **security groups** to allow WordPress to connect to RDS.

#### Terraform Implementation

```hcl
resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username           = "admin"
  password           = var.db_password
}
```

### 4. EFS Setup for WordPress Files

#### Objective

- Use **Amazon EFS** to store WordPress files for scalability.
- Mount EFS on WordPress instances.

#### Terraform Implementation

```hcl
resource "aws_efs_file_system" "wordpress_efs" {
  performance_mode = "generalPurpose"
}
```

### 5. Application Load Balancer

#### Objective

- Create an **Application Load Balancer** for distributing traffic.
- Configure **listener rules** for routing requests to instances.

#### Terraform Implementation

```hcl
resource "aws_lb" "wordpress_lb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
}
```

### 6. Auto Scaling Group

#### Objective

- Implement **Auto Scaling** to adjust the number of instances dynamically.
- Define **scaling policies** based on CPU utilization.

#### Terraform Implementation

```hcl
resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity     = 2
  max_size            = 4
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.private.id]
}
```

---

## Deployment Steps

1. Clone this repository:

   ```sh
   git clone https://github.com/your-repo/terraform-wordpress.git
   cd terraform-wordpress
   ```

2. Initialize Terraform:

   ```sh
   terraform init
   ```

3. Plan the deployment:

   ```sh
   terraform plan
   ```

4. Apply the configuration:

   ```sh
   terraform apply -auto-approve
   ```

5. Retrieve the WordPress Load Balancer URL:

   ```sh
   terraform output wordpress_lb_dns
   ```

6. Open the URL in a browser to access your WordPress site.

---

## Security Measures Implemented

- **VPC isolation** to ensure network security.
- **Security groups** restricting access to necessary ports.
- **Auto Scaling** for high availability and resilience.
- **EFS** to maintain data consistency across multiple instances.

---

## Testing Auto Scaling

To test the **Auto Scaling** feature:

- Simulate high traffic by using a load-testing tool like **Apache Benchmark**:

  ```sh
  ab -n 1000 -c 10 http://your-wordpress-lb.com/
  ```

- Monitor instance scaling using AWS **EC2 Auto Scaling console**.

---

## Cleanup

To destroy the infrastructure and avoid additional costs:

```sh
terraform destroy -auto-approve
```

---

## Conclusion

This Terraform project successfully automates the deployment of a **scalable WordPress website** on AWS. It incorporates best practices in security, networking, and high availability using **VPC, RDS, EFS, ALB, and Auto Scaling**.

🚀 **Happy Deploying!** 🚀
