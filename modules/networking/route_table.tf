
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
