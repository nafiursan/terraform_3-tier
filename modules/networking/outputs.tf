output "vpc_id" {
    value =aws_vpc.this_vpc.id
}

output "pub_sub_ids" {
    value = local.pub_sub_ids
}

output "db_sub_ids" {
    value = var.db_ciders
}

output "ALB_dns" {
  value = aws_lb.app_alb.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.db_instance.address
}

output "db_port" {
    value = aws_db_instance.db_instance.port
}

output "azs" {
  value = data.aws_availability_zones.az.names
}
