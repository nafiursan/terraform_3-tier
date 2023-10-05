resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [for subnet in aws_subnet.db : subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}
