
variable "vpc_cidr" {
    default = "10.0.0.0/16"
    type        = string
}

variable "pub_ciders" {

   default = ["10.0.0.0/24" , "10.0.1.0/24" ]
   type = list(string)
  
}

variable "db_ciders" {
  default = ["10.0.10.0/24" , "10.0.11.0/24" ]
  type = list(string)
  
}

variable "port" {
  default = "8000"
  type        = string
  
}

variable "db_allocated_space" {
  default = "10"
  type        = string
  
}

variable "db_engine" {
  default = "mysql"
  type        = string
  
}

variable "db_engine_version" {
  default = "8.0.33"
  type        = string
  
}

variable "vpc_tags" {
  default = {
     Name= "My_tag"
  }
  
}

variable "instance_class" {
  default ="db.t2.micro"
  type        = string
}

variable "db_name" {
  default = "laravel"
  type        = string
  sensitive = true
  
}

variable "db_pw" {
  default = "qwerty12"
  type        = string
  sensitive = true
  
}

variable "db_username" {
  default = "root"
  type        = string
  sensitive = true
  
}
