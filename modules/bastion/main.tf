
resource "aws_security_group" "bastion_sg" {
  name        = "gbenga-online-bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere (in production, restrict this)"
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
    Name = "gbenga-online-bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ami-05b10e08d247fb927"
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnets[0]
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "gbenga-online-bastion"
  }
}

