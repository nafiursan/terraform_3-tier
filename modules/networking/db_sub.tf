
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
