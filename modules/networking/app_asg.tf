
################################################################################
# Launch Template (app-tier)
################################################################################

resource "aws_launch_template" "app_lt" {
  name_prefix = "app-"
  image_id = data.aws_ami.amazon-linux-2-latest.image_id
  instance_type = "t2.micro"
  key_name = "naf" 
  tags = {Name: "naf"}
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.allow_tls.id]
  }
}

################################################################################
# Auto Scaling Group (app-tier)
################################################################################

resource "aws_autoscaling_group" "app_asg" {
  vpc_zone_identifier = [for i in aws_subnet.public[*] : i.id]
  desired_capacity = 1
  max_size = 3
  min_size = 1
  #for ALB instead of loadbalancer_id target_group_arns is used.
  target_group_arns = [aws_lb_target_group.app_tg.arn]
    
  launch_template {
    id = aws_launch_template.app_lt.id
    version = aws_launch_template.app_lt.latest_version
  }
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.this_vpc.id

   ingress {
     from_port = 443
     to_port = 443
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 22 for SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 8000 for output"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "allow_tls"
  }
}

