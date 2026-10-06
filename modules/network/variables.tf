variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC."
  type        = string
  default     = "app-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "data_subnet_cidrs" {
  description = "CIDR blocks for data subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones used for the VPC."
  type        = list(string)
}

variable "tags" {
  description = "Default resource tags applied to all resources."
  type        = map(string)
  default     = {}
}
