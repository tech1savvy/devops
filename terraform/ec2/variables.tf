
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where resources will be created"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to launch resources into"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key pair"
}

variable "private_key_path" {
  type        = string
  description = "Path to the private key file for SSH access"
  sensitive   = true
}

variable "ami" {
  type        = string
  description = "The AMI to use for the instances"
}
