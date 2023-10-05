
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

