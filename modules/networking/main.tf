
# # Define an AWS launch configuration
# resource "aws_launch_configuration" "example" {
#   name_prefix   = "example-"
#   image_id      = "ami-02daa508cbc334270"
#   instance_type = "t2.micro"

#   security_groups = [aws_security_group.allow_tls.id]
#   key_name        = "naf"

#   user_data = <<-EOF
#               #!/bin/bash
#               # Your user data script here
#               EOF
# }

# resource "aws_launch_template" "foobar" {
#   name_prefix   = "foobar"
#   image_id      = "ami-02daa508cbc334270"
#   instance_type = "t2.micro"
# }

# resource "aws_autoscaling_group" "bar" {
#   availability_zones = ["us-west-1a"]
#   desired_capacity   = 1
#   max_size           = 1
#   min_size           = 1

#   launch_template {
#     id      = aws_launch_template.foobar.id
#     version = "$Latest"
#   }
# }