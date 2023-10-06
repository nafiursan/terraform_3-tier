resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
