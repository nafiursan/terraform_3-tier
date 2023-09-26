#create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = var.vpc_tags
}

# Create public subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    count=length(var.pub_ciders) 
    #count = var.subnet_count
    cidr_block = var.pub_ciders[count.index]
    availability_zone = data.aws_availability_zones.az.names[count.index]
    tags ={
      Name = "Public-${count.index + 1}" 
    }   
}

# output "availability_zone_names" {    
#   value = aws_vpc.main.cidr_block
# }

#   pub_sub_ids =aws_subnet.public.*.id
#  # priv_sub_ids =aws_subnet.private.*.id
#   azs = data.aws_availability_zones.az.names

# Create IGW
resource "aws_internet_gateway" "main" {
  vpc_id =aws_vpc.main.id 
}

# Create Route Table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

# Attach route table with IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

  tags = {
    Name = "public-route-table"
  }
}

# Associate route-Table with public subnet
resource "aws_route_table_association" "public" {
  count = length(var.pub_ciders)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}



#create aws instance in each subnet
resource "aws_instance" "main" {
    ami = "ami-02daa508cbc334270"
    count = length(var.pub_ciders)
    subnet_id = aws_subnet.public.*.id[count.index]
    key_name                    = "naf"
    associate_public_ip_address = true
    instance_type = "t2.micro"
        tags ={
      Name = "new-${count.index + 1}" 
    } 
    vpc_security_group_ids = [ aws_security_group.allow_tls.id ]
    user_data = <<-EOF
              #!/bin/bash         
              sudo yum update -y 
              sudo yum install docker -y
              sudo systemctl start docker
              sudo docker run -p 80:8000 -d zuheb/django_blog
              # sudo yum install -y amazon-linux-extras
              # sudo amazon-linux-extras enable nginx1
              # sudo amazon-linux-extras install nginx1 -y
              # sudo systemctl start nginx.service
              # sudo systemctl enable httpd.service
              EOF
 
} 

# resource "aws_subnet" "private" {
#     vpc_id = aws_vpc.main.id
#     count=length(var.priv_ciders) 
#     #count = var.subnet_count
#     cidr_block = var.priv_ciders[count.index]
#     availability_zone = local.azs[count.index]
#     tags ={
#       Name = "Private-${count.index + 1}" 
#     }   
# } 

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id


  ingress {
     from_port =80
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


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "example" {
  count            = length(var.pub_ciders) 
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.main[count.index].id
}


resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.allow_tls.id ]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "tf_alb_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
