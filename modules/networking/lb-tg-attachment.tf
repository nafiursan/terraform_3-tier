
resource "aws_lb_target_group_attachment" "example" {
  count            = length(var.pub_ciders) 
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.main[count.index].id
}