resource "aws_lb_listener" "tf_alb_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

