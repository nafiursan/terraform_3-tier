
################################################################################
# VPC inputs
################################################################################

variable "vpc_cidr" {
    default = "10.0.0.0/16"
    type        = string
}

variable "vpc_tags" {

  default = {
     Name= "tf-vpc"
  }

}

################################################################################
# Cider block input
################################################################################

variable "pub_ciders" {
   default = ["10.0.0.0/24" , "10.0.1.0/24" ]
   type = list(string) 
}

variable "priv_ciders" {
   default = ["10.0.20.0/24" , "10.0.21.0/24" ]
   type = list(string) 
}

variable "db_ciders" {
  default = ["10.0.10.0/24" , "10.0.11.0/24" ]
  type = list(string) 
}

################################################################################
# Port input
################################################################################

variable "app_port" {
  default = "3000"
  type        = string
}

variable "web_port" {
  default = "8000"
  type = string
}

variable "db_port" {
  default = "3306"
  type = string
}

################################################################################
# DB tier related input
################################################################################

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

variable "db_instance_class" {
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

################################################################################
# Web tier related input
################################################################################

variable "web_instance_class" {
  default ="t2.micro"
  type        = string
}

variable "web_asg_desired_capacity" {
  default = 1
  type = number
}

variable "web_asg_min_size" {
  default = 1
  type = number
}

variable "web_asg_max_size" {
  default = 3
  type = number
}


################################################################################
# app tier related input
################################################################################

variable "app_instance_class" {
  default ="t2.micro"
  type        = string
}

variable "app_asg_desired_capacity" {
  default = 1
  type = number
}

variable "app_asg_min_size" {
  default = 1
  type = number
}

variable "app_asg_max_size" {
  default = 3
  type = number
}
