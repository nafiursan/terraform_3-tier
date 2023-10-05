
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "vpc_tags" {
  default = {
     Name= "My_tag"
  }
}

variable "db_name" {
  default = "laravel"
  
}

variable "db_pw" {
  default = "qwerty12"
  
}

variable "db_username" {
  default = "root"
  
}

variable "pub_ciders" {
  default = ["10.0.0.0/24" , "10.0.1.0/24" ]
  
}

variable "priv_ciders" {
  default = ["10.0.2.0/24" , "10.0.3.0/24" ]
  
}

variable "db_ciders" {
  default = ["10.0.4.0/24" , "10.0.5.0/24" ]
  
}



