
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
# Create Private Subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    count=length(var.priv_ciders) 
    cidr_block = var.priv_ciders[count.index]
    availability_zone = local.azs[count.index]
    tags ={
      Name = "Private-${count.index + 1}" 
    }   
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
