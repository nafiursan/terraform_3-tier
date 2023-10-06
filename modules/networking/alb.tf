
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.allow_alb.id ]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}
