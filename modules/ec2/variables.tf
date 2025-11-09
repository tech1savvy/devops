variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for the instance"
  type        = string
}



variable "ami" {
  description = "AMI for the instance"
  type        = string
}

