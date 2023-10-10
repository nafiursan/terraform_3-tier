
################################################################################
# Application Load balancer
################################################################################

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

################################################################################
# Load Balancer Listener 
################################################################################

resource "aws_lb_listener" "tf_alb_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

################################################################################
# Target Group of the Load Balancer
################################################################################

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = aws_vpc.this_vpc.id
}

################################################################################
# Load Balancer - Target Group Attachment
################################################################################
# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.bar.id
  lb_target_group_arn    = aws_lb_target_group.test.arn
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "allow_alb" {
  name        = "allow_alb"
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
    Name = "allow_alb"
  }
}
