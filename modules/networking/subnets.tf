
#Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = var.vpc_tags
}

# Create DB Subnet
resource "aws_subnet" "db" {
    vpc_id = aws_vpc.main.id
    count=length(var.db_ciders) 
    cidr_block = var.db_ciders[count.index]
    availability_zone = local.azs[count.index]
    tags ={
      Name = "db-${count.index + 1}" 
    }   
} 

# Create Public Subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    count=length(var.pub_ciders) 
    cidr_block = var.pub_ciders[count.index]
    availability_zone = local.azs[count.index]
    tags ={
      Name = "Public-${count.index + 1}" 
    }   
}

# Create Route Table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

# Attach route table with IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate route-Table with public subnet
resource "aws_route_table_association" "public" {
  count = length(var.pub_ciders)
  subnet_id      = local.pub_sub_ids[count.index]  
  route_table_id = aws_route_table.public.id
}

