variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_cidr_vpc" {
  description = "CIDR for Custom VPC"
  default     = "20.0.0.0/16"
}

variable "aws_cidr_private_subnet" {
  description = "CIDR for Private Subnet"
  default     = "20.0.1.0/24"
}

variable "aws_cidr_public_subnet" {
  description = "CIDR for Public Subnet"
  default     = "20.0.2.0/24"
}

variable "aws_listener_port" {
  description = "listener port for load balancer"
  default     = "8080"
}

variable "aws_ami_instance" {
  description = "Default AMI for instances"
  default     = "ami-0756fbca465a59a30"
}

variable "aws_ami_launch_conf" {
  description = "Default AMI for launch configuration"
  default     = "ami-0756fbca465a59a30"
}

variable "aws_availability_zone" {
  description = "Default zone for AWS"
  default     = "us-east-1e"
}
