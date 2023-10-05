
#create aws instance in each subnet
resource "aws_instance" "main" {
    ami = "ami-02daa508cbc334270"
    count = length(var.pub_ciders)
    subnet_id = local.pub_sub_ids[count.index]
    key_name                    = "naf"
    associate_public_ip_address = true
    instance_type = "t2.micro"
        tags ={
      Name = "new-${count.index + 1}" 
    } 

    vpc_security_group_ids = [ aws_security_group.allow_tls.id ]
    user_data = <<-EOF
              #!/bin/bash
              # Created by NR
              # date: 10-03-2023  
              sudo amazon-linux-extras enable php8.0
              sudo amazon-linux-extras install php8.0 -y
              sudo yum install php-xml -y
              sudo yum install php-mbstring -y
              sudo yum install mysql -y

              sudo curl -sS https://getcomposer.org/installer | sudo php
              sudo mv composer.phar /usr/local/bin/composer
              sudo ln -s /usr/local/bin/composer /usr/bin/composer

              sudo yum install git -y
              git clone https://github.com/nafiurrashid/multiuser-blog.git
              cd multiuser-blog/
              sudo composer install
              sudo cp .env.example  .env
              #-------------------       
              # sudo yum update -y 
              # sudo yum install docker -y
              # sudo systemctl start docker
              # sudo docker run -p 80:8000 -d zuheb/django_blog
              #----------------------
              # sudo yum install -y amazon-linux-extras
              # sudo amazon-linux-extras enable nginx1
              # sudo amazon-linux-extras install nginx1 -y
              # sudo systemctl start nginx.service
              # sudo systemctl enable httpd.service
              EOF
 
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
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}



resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [for subnet in aws_subnet.db : subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "example" {
  
  allocated_storage = 10
  engine = "mysql"
  engine_version = "8.0.33"
  instance_class = "db.t2.micro"
  db_name = var.db_name
  password = var.db_pw
  username = var.db_username
  skip_final_snapshot = true
  vpc_security_group_ids = [ aws_security_group.allow_rds.id ]
  db_subnet_group_name = aws_db_subnet_group.default.name
  tags = {
    Name = "larvel-db"
  }
 
}
