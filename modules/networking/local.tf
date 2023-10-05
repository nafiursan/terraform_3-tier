locals {
  pub_sub_ids =aws_subnet.public.*.id
  azs = data.aws_availability_zones.az.names

}