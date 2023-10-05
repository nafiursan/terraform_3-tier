module "networking" {
  source = "./modules/networking"
  # vpc_cidr = var.vpc_cidr
  vpc_cidr    = "10.200.0.0/16"
  pub_ciders  = ["10.200.0.0/24", "10.200.1.0/24"]
  priv_ciders = ["10.200.2.0/24", "10.200.3.0/24"]
  db_ciders   = ["10.200.4.0/24", "10.200.5.0/24"]
}

# module "ec2" {
#   source = "./modules/ec2"
#   ami_id ="ami-02daa508cbc334270"
#   subnet_id = module.networking.pub_sub_ids

# }

# module "servers" {
#   source = "./modules/servers"
#   # subnet_id = module.networking.pub_sub_ids[count.index]

# }

# module "stage" {
#   source     = "./modules/networking"
#   #vpc_cidr = var.vpc_cidr
#   vpc_cidr   = "10.300.0.0/16"
#   pub_ciders = ["10.300.0.0/24", "10.300.1.0/24"]
#   priv_ciders = ["10.300.2.0/24", "10.300.3.0/24"]
# }

# module "ec2" {
#   source    = "./modules/ec2"
#   ami_id    = "ami-02daa508cbc334270"
#   subnet_id = module.dev.pub_sub_ids[0]

# }