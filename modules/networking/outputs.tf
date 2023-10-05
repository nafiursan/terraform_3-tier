output "vpc_id" {
    value = aws_vpc.main.id
}

output "pub_sub_ids" {
    # value = aws_subnet.public.*.id
    value = local.pub_sub_ids
}

output "priv_sub_ids" {
    # value = aws_subnet.private.*.id
    value = local.priv_sub_ids
}

