
################################################################################
# RDS Instance
################################################################################

resource "aws_db_instance" "db_instance" {
  allocated_storage = var.db_allocated_space
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.instance_class
  db_name = var.db_name
  password = var.db_pw
  username = var.db_username
  skip_final_snapshot = true
  # multi_az = true
  vpc_security_group_ids = [ aws_security_group.allow_rds.id ]
  db_subnet_group_name = aws_db_subnet_group.default.name
  tags = {
    Name = "larvel-db"
  }
}

################################################################################
# Database Subnet Group
################################################################################

resource "aws_db_subnet_group" "default" {
  name       = "db_subnet_group"
  subnet_ids = [for subnet in aws_subnet.db : subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow 3306 inbound traffic"
  vpc_id      = aws_vpc.this_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.this_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_rds"
  }
}
