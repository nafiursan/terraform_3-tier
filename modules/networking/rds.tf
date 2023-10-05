
resource "aws_db_instance" "example" {
  
  allocated_storage = 10
  engine = "mysql"
  engine_version = "8.0.33"
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