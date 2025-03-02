resource "aws_db_subnet_group" "this" {
  name       = "gbenga-online-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "gbenga-online-db-subnet-group"
  }
}

resource "aws_security_group" "db_sg" {
  name   = "gbenga-online-db-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow MySQL from WordPress servers"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.wordpress_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gbenga-online-db-sg"
  }
}

resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az               = true
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "gbenga-online-wordpress-db"
  }
}
