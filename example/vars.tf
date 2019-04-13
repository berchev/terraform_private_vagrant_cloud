variable "aws_access_key" {
  description = "Your access key to AWS"
}

variable "aws_secret_key" {
  description = "Your secret key to AWS"
}

variable "region" {
  description = "Desired AWS region"
}

variable "instance_type" {
  description = "Desired AWS instance type - t2.micro, t2.large, etc"
}

variable "ssh_key_name" {
  description = "Name of your AWS ssh key pair, without .pem"
}

variable "private_key" {
  description = "Full path to your AWS private key"
}

variable "ami" {
  description = "Desired AMI from AWS, depending on region"
}
