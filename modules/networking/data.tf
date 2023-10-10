
data "aws_availability_zones" "az" {
    state = "available"
}

data "aws_ami" "amazon-linux-2-latest" {
  most_recent = true
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}