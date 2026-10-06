variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for application hosts."
  type        = string
}

variable "key_name" {
  description = "AWS key pair name to attach to EC2 instances."
  type        = string
}

variable "dashboard_asg_min" {
  type = number
}

variable "dashboard_asg_max" {
  type = number
}

variable "dashboard_asg_desired_capacity" {
  type = number
}

variable "counting_asg_min" {
  type = number
}

variable "counting_asg_max" {
  type = number
}

variable "counting_asg_desired_capacity" {
  type = number
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
  description = "Optional Route53 hosted zone ID for dashboard DNS record."
  type        = string
  default     = ""
}

variable "route53_hostname" {
  description = "Optional Route53 hostname to create for the public dashboard URL."
  type        = string
  default     = ""
}

variable "alarm_threshold_cpu" {
  description = "CPU percentage threshold that triggers a CloudWatch alarm."
  type        = number
  default     = 80
}

variable "alarm_evaluation_periods" {
  description = "Number of evaluation periods for CloudWatch alarms."
  type        = number
  default     = 2
}

variable "alarm_period_seconds" {
  description = "CloudWatch alarm period in seconds."
  type        = number
  default     = 120
}

variable "tags" {
  description = "Additional tags for all resources."
  type        = map(string)
  default     = {}
}
