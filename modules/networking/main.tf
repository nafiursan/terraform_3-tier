
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