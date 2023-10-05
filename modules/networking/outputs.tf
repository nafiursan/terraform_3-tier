output "vpc_id" {
    value = aws_vpc.main.id
}

output "pub_sub_ids" {
    # value = aws_subnet.public.*.id
    value = local.pub_sub_ids
}

output "db_sub_ids" {
    value = var.db_ciders
  
}
