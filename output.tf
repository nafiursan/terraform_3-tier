output "public_subnets" {
  value = module.networking.pub_sub_ids
}

output "db_subnets" {
  value = module.networking.db_sub_ids
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "alb_endpoint" {
  value = module.networking.ALB_dns
}

output "db_endpoint" {
  value = module.networking.db_endpoint
  #sensitive = true
}

output "db_port" {
  value = module.networking.db_port

}

# output "server_ips" {
#   value = module.networking.server_ips
# }

output "azs" {
  value = module.networking.azs
}


