
################################################################################
# Application Load balancer (web-tier)
################################################################################

resource "aws_lb" "web-alb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.web_alb_sg.id ]
  subnets            = [for subnet in aws_subnet.private : subnet.id]
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }

}

################################################################################
# Load Balancer Listener  (web-tier)
################################################################################

resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = var.web_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }

}

################################################################################
# Target Group of the Load Balancer (web-tier)
################################################################################

resource "aws_lb_target_group" "web-tg" {
  name     = "Web-target-group"
  port     = var.web_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.this_vpc.id
}

################################################################################
# Load Balancer - Target Group Attachment (web-tier)
################################################################################

resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn    = aws_lb_target_group.web-tg.arn
}

################################################################################
# Security Group (web-tier)
################################################################################

resource "aws_security_group" "web_alb_sg" {
  name        = "web_alb_sg"
  description = "Allow alb inbound traffic"
  vpc_id      = aws_vpc.this_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 8000 for output"
    from_port   = var.web_port
    to_port     = var.web_port
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
    Name = "web_alb_sg"
  }
}

################################################################################
# Launch Template (web-tier)
################################################################################

resource "aws_launch_template" "web_lt" {
  name_prefix = "web-"
  image_id = data.aws_ami.amazon-linux-2-latest.image_id
  instance_type = var.web_instance_class
  key_name = "naf" 
  tags = {Name: "naf"}

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.web_ec2_sg.id]
  }

}

################################################################################
# Auto Scaling Group (web-tier)
################################################################################

resource "aws_autoscaling_group" "web_asg" {
  vpc_zone_identifier = [for i in aws_subnet.private[*] : i.id]
  desired_capacity = var.web_asg_desired_capacity
  max_size = var.web_asg_max_size
  min_size = var.web_asg_min_size
  #for ALB instead of loadbalancer_id target_group_arns is used.
  target_group_arns = [aws_lb_target_group.web-tg.arn]
    
  launch_template {
    id = aws_launch_template.web_lt.id
    version = aws_launch_template.web_lt.latest_version
  }

}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "web_ec2_sg" {
  name        = "web_ec2_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.this_vpc.id

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
    description = "Allow web Port for output"
    from_port   = var.web_port
    to_port     = var.web_port
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
    Name = "web_ec2_sg"
  }

}
