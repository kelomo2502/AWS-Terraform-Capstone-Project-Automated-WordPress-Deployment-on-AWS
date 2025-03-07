resource "aws_efs_file_system" "this" {
  creation_token = "gbenga-online-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "gbenga-online-efs"
  }
}

resource "aws_security_group" "efs_sg" {
  name   = "gbenga-online-efs-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [var.wordpress_sg_id]
  }

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.bastion_sg]
  }

  ingress {
    description = "Allow NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gbenga-online-efs-sg"
  }
}

# Create a mount target in each private subnet
resource "aws_efs_mount_target" "this" {
  count           = length(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

