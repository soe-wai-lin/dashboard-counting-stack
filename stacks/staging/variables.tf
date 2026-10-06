variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "vpc_name" {
  type    = string
  default = "staging-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.10.0/24", "10.20.11.0/24"]
}

variable "data_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.20.0/24", "10.20.21.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "instance_type" {
  type    = string
  default = "t3.small"
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
  default = 2
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
  default = 2
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
  default = "staging"
}

variable "alarm_threshold_cpu" {
  type    = number
  default = 80
}

variable "alarm_evaluation_periods" {
  type    = number
  default = 2
}

variable "alarm_period_seconds" {
  type    = number
  default = 120
}
