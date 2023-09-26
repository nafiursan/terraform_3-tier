resource "aws_instance" "main" {
    # count= module.networking.local.pub_sub_ids
    count         = length(var.subnet_ids)
    ami = var.ami_id
    instance_type = var.instance_type
    
    subnet_id     = var.subnet_id[count.index]
}