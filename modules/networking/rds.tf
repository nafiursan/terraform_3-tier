
resource "aws_db_instance" "example" {
  
  allocated_storage = var.db_allocated_space
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.instance_class
  db_name = var.db_name
  password = var.db_pw
  username = var.db_username
  skip_final_snapshot = true
  vpc_security_group_ids = [ aws_security_group.allow_rds.id ]
  db_subnet_group_name = aws_db_subnet_group.default.name
  tags = {
    Name = "larvel-db"
  }
 
}