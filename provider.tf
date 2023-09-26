provider "aws" {
  region = "us-west-1"
}

#test-bucket-naf
terraform {
  backend "s3" {
    bucket = "test-bucket-naf"
    region = "us-west-1"
    key    = "terraform.tfstate"
  }
}