variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "vpc_name" {
  type    = string
  default = "production-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.30.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.1.0/24", "10.30.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.10.0/24", "10.30.11.0/24"]
}

variable "data_subnet_cidrs" {
  type    = list(string)
  default = ["10.30.20.0/24", "10.30.21.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = "jenkins-key"
}

variable "dashboard_asg_min" {
  type    = number
  default = 1
}

variable "dashboard_asg_max" {
  type    = number
  default = 1
}

variable "dashboard_asg_desired_capacity" {
  type    = number
  default = 1
}

variable "counting_asg_min" {
  type    = number
  default = 1
}

variable "counting_asg_max" {
  type    = number
  default = 1
}

variable "counting_asg_desired_capacity" {
  type    = number
  default = 1
}

variable "dashboard_tg_port" {
  type    = number
  default = 9000
}

variable "counting_tg_port" {
  type    = number
  default = 7777
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "http_port" {
  type    = number
  default = 80
}

variable "https_port" {
  type    = number
  default = 443
}

variable "route53_zone_id" {
  type    = string
  default = ""
}

variable "route53_hostname" {
  type    = string
  default = "www"
}

variable "alarm_threshold_cpu" {
  type    = number
  default = 75
}

variable "alarm_evaluation_periods" {
  type    = number
  default = 2
}

variable "alarm_period_seconds" {
  type    = number
  default = 120
}
