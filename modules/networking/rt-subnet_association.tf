
# Associate route-Table with public subnet
resource "aws_route_table_association" "public" {
  count = length(var.pub_ciders)
  subnet_id      = local.pub_sub_ids[count.index]  
  route_table_id = aws_route_table.public.id
}
