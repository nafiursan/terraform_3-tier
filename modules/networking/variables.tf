
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "pub_ciders" {
  default = ["10.0.0.0/24" , "10.0.1.0/24" ]
  
}

variable "db_ciders" {
  default = ["10.0.4.0/24" , "10.0.5.0/24" ]
  
}

variable "vpc_tags" {
  default = {
     Name= "My_tag"
  }
}

variable "instance_class" {
  default ="db.t2.micro"
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
