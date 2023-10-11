
################################################################################
# Create VPC
################################################################################

#Create VPC
resource "aws_vpc" "this_vpc" {
  cidr_block = var.vpc_cidr
  tags = var.vpc_tags
}

################################################################################
# Create Database Subnet 
################################################################################

# Create DB Subnet
resource "aws_subnet" "db" {
    vpc_id = aws_vpc.this_vpc.id
    count=length(var.db_ciders) 
    cidr_block = var.db_ciders[count.index]
    availability_zone = local.azs[count.index]
    tags ={
      Name = "db-${count.index + 1}" 
    }   
} 

################################################################################
# Create Public Subnet 
################################################################################

# Create Public Subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.this_vpc.id
    count=length(var.pub_ciders) 
    cidr_block = var.pub_ciders[count.index]
    availability_zone = local.azs[count.index]
    tags ={
      Name = "Public-${count.index + 1}" 
    }   
}

################################################################################
# Create Private Subnet 
################################################################################

# Create Private Subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.this_vpc.id
    count=length(var.priv_ciders) 
    cidr_block = var.priv_ciders[count.index]
    availability_zone = local.azs[count.index]
    tags ={
      Name = "Private-${count.index + 1}" 
    }   
}

################################################################################
# Create Internet Gateway
################################################################################

# Create IGW
resource "aws_internet_gateway" "main" {
  vpc_id =aws_vpc.this_vpc.id 
}
##################################################
# Create Nat-Gateway
################################################################################


resource "aws_nat_gateway" "this" {
  connectivity_type = "private"
  # allocation_id = aws_eip.nat_eip.id
  #aws_eip
  # count=length(var.priv_ciders) 
  subnet_id =  aws_subnet.private[0].id
}

################################################################################
# Create Public Route Table
################################################################################

# Create public Route Table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this_vpc.id

# Attach route table with IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

################################################################################
# Create Private Route Table
################################################################################

# Create private Route Table 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name = "private-route-table"
  }
}
################################################################################
# Associate Route-Table (private)
################################################################################
resource "aws_route_table_association" "private_route_table_association" {
  route_table_id = aws_route_table.private.id
  count=length(var.priv_ciders) 
  subnet_id =  aws_subnet.private[count.index].id
}



################################################################################
# Associate Route-Table (public)
################################################################################

# Associate route-Table with public subnet
resource "aws_route_table_association" "public" {
  count = length(var.pub_ciders)
  subnet_id      = local.pub_sub_ids[count.index]  
  route_table_id = aws_route_table.public.id
}



resource "aws_eip" "nat_eip" {}

# Create a route in the private route table to send traffic through the NAT gateway
# resource "aws_route" "private_subnet_route" {

#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.this.id
# }

