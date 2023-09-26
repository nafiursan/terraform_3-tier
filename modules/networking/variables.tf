variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "vpc_tags" {
  default = {
     Name= "nafiur_tag"
  }
}

# variable "subnet_count" {
#   default = 2
  
# }

variable "pub_ciders" {
  default = ["10.0.0.0/24" , "10.0.1.0/24" ]
  
}

variable "priv_ciders" {
  default = ["10.0.2.0/24" , "10.0.3.0/24" ]
  
}



