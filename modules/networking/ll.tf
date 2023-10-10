resource "aws_launch_template" "foobar" {
  name_prefix = "pre-"
  image_id = data.aws_ami.amazon-linux-2-latest.image_id
  instance_type = "t2.micro"
  key_name = "naf" 
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.allow_tls.id]
  }
}

resource "aws_autoscaling_group" "bar" {
  # availability_zones = ["us-west-1a", "us-west-1c"]
  vpc_zone_identifier = [for i in aws_subnet.public[*] : i.id]
  desired_capacity = 2
  max_size = 3
  min_size = 2
  #for ALB instead of loadbalancer_id target_group_arns is used.
  target_group_arns = [aws_lb_target_group.test.arn]
  # depends_on = [ aws_launch_template.foobar ]
  


  
  launch_template {
    id = aws_launch_template.foobar.id
    version = aws_launch_template.foobar.latest_version
    # "$Latest"
  }
}

# # Create a new ALB Target Group attachment
# resource "aws_autoscaling_attachment" "example" {
#   autoscaling_group_name = aws_autoscaling_group.bar.id
#   lb_target_group_arn = aws_lb_target_group.test.arn
# }
