
#Create aws instance in each subnet
resource "aws_instance" "main" {
    ami= data.aws_ami.amazon-linux-2-latest.image_id
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
              # sudo amazon-linux-extras enable php8.0
              # sudo amazon-linux-extras install php8.0 -y
              # sudo yum install php-xml -y
              # sudo yum install php-mbstring -y
              # sudo yum install mysql -y

              # sudo curl -sS https://getcomposer.org/installer | sudo php
              # sudo mv composer.phar /usr/local/bin/composer
              # sudo ln -s /usr/local/bin/composer /usr/bin/composer

              # sudo yum install git -y
              # git clone https://github.com/nafiurrashid/multiuser-blog.git
              # cd multiuser-blog/
              # sudo composer install
              # sudo cp .env.example  .env
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

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

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
