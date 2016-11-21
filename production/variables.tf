variable "access_key" {}
variable "secret_key" {}
variable "route53_zone" {}
variable "domain_name" {}
variable "internal_domain_name" {}

variable "aws_region" {
  default = "eu-west-1"
}

# Our own Custom AMI: Frecra HelloWorld - 1.0.20291520
variable "aws_amis" {
  type = "map"
  default = {
    eu-west-1 = "ami-bd4914ce"
    us-east-1 = "ami-88d6e09f"
  }
}



variable "availability_zones" {
  type = "map"
  default = {
    eu-west-1 = "eu-west-1a,eu-west-1b"
    us-east-1 = "us-east-1c,us-east-1d"
  }
}


variable "key_name" {
  type = "map"
  default = {
    eu-west-1 = "frecratest"
    us-east-1 = "frecratest-us"
  }
}

