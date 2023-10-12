
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
# Create Public Subnet (For Application tier)
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
# Create Private Subnet (For Web tier)
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
# Create Internet Gateway  (For Application tier)
################################################################################

resource "aws_internet_gateway" "main" {
  vpc_id =aws_vpc.this_vpc.id 
}

##################################################
# Create Nat-Gateway (For Web tier)
################################################################################

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_eip.id 
  subnet_id =  aws_subnet.private[0].id
}

################################################################################
# Create Public Route Table (For Application tier)
################################################################################

# Create public Route Table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }

}

################################################################################
# Create Private Route Table (For Web tier)
################################################################################

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
# Associate Route-Table (With the web tier public subnets)
################################################################################

resource "aws_route_table_association" "public" {
  count = length(var.pub_ciders)
  subnet_id      = local.pub_sub_ids[count.index]  
  route_table_id = aws_route_table.public.id
}

################################################################################
# Associate Route-Table (With the web tier private subnets)
################################################################################

resource "aws_route_table_association" "private_route_table_association" {
  route_table_id = aws_route_table.private.id
  count=length(var.priv_ciders) 
  subnet_id =  aws_subnet.private[count.index].id
}

resource "aws_eip" "nat_eip" {}
