output "net_out" {
  value = module.networking.pub_sub_ids
}

output "db_out" {
  value = module.networking.db_sub_ids
}

output "vpc_id" {
  value = module.networking.vpc_id
}