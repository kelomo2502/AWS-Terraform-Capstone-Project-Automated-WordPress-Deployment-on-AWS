resource "aws_security_group" "wordpress_sg" {
  name        = "gbenga-online-wordpress-sg"
  description = "Security group for WordPress instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  # Allow SSH if needed (should be locked down in production)
  ingress {
    description = "Allow SSH (for debugging, restrict in production)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gbenga-online-wordpress-sg"
  }
}

resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "gbenga-online-wordpress-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.wordpress_sg.id]
  }

  user_data = base64encode(var.user_data)
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "gbenga-online-wordpress"
    }
  }
}

resource "aws_autoscaling_group" "wordpress_asg" {
  name                      = "gbenga-online-wordpress-asg"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = var.private_subnets

  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.alb_target_group_arn]

  tag {
    key                 = "Name"
    value               = "gbenga-online-wordpress"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
