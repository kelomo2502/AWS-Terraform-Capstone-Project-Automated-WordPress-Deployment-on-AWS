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

  ingress {
    description     = "Allow HTTPS traffic from ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  # Allow SSH if needed (should be locked down in production)
  ingress {
    description = "Allow SSH (for debugging, restrict in production)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.bastion_sg]
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
  key_name      = "Jenkins_server"


  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.wordpress_sg.id]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "gbenga-online-wordpress"
    }
  }
  user_data = base64encode(<<-EOF
  #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd php php-mysqlnd php-fpm php-json php-mbstring php-xml php-gd amazon-efs-utils
    sudo dnf install mariadb105
    sudo systemctl enable httpd
    sudo systemctl start httpd
    EFS_ID="${var.efs_id}.efs.${var.aws_region}.amazonaws.com"

    MOUNT_POINT="/var/www/html"
    sudo mkdir -p $MOUNT_POINT
    echo "$EFS_ID:/ $MOUNT_POINT nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" | sudo tee -a /etc/fstab
    sleep 30
    sudo mount -a

    cd $MOUNT_POINT
    sudo wget https://wordpress.org/latest.tar.gz
    sudo tar -xzf latest.tar.gz
    sudo mv wordpress/* .
    sudo rm -rf wordpress latest.tar.gz

    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${var.db_name}/g" wp-config.php
    sed -i "s/username_here/${var.db_user}/g" wp-config.php
    sed -i "s/password_here/${var.db_password}/g" wp-config.php
    sed -i "s/localhost/${var.rds_endpoint}/g" wp-config.php

    # Set permissions
    sudo chown -R apache:apache /var/www/html
    sudo chmod -R 755 /var/www/html
    sudo systemctl restart httpd
EOF
)



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
