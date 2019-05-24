variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
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
