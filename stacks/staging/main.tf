terraform {
  required_version = ">= 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "swl-dashboard-counting-stack-staging-tfstate"
    key          = "dashboard-counting-stack/staging/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../../modules/network"

  environment          = var.environment
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  data_subnet_cidrs    = var.data_subnet_cidrs
  availability_zones   = var.availability_zones
  tags = {
    owner       = "platform"
    environment = var.environment
    cost-center = "engineering"
    application = "dashboard-counting-stack"
  }
}

module "application" {
  source = "../../modules/application"

  environment                    = var.environment
  vpc_id                         = module.network.vpc_id
  public_subnet_ids              = module.network.public_subnet_ids
  private_subnet_ids             = module.network.private_subnet_ids
  instance_type                  = var.instance_type
  key_name                       = var.key_name
  dashboard_asg_min              = var.dashboard_asg_min
  dashboard_asg_max              = var.dashboard_asg_max
  dashboard_asg_desired_capacity = var.dashboard_asg_desired_capacity
  counting_asg_min               = var.counting_asg_min
  counting_asg_max               = var.counting_asg_max
  counting_asg_desired_capacity  = var.counting_asg_desired_capacity
  dashboard_tg_port              = var.dashboard_tg_port
  counting_tg_port               = var.counting_tg_port
  ssh_port                       = var.ssh_port
  http_port                      = var.http_port
  https_port                     = var.https_port
  route53_zone_id                = var.route53_zone_id
  route53_hostname               = var.route53_hostname
  alarm_threshold_cpu            = var.alarm_threshold_cpu
  alarm_evaluation_periods       = var.alarm_evaluation_periods
  alarm_period_seconds           = var.alarm_period_seconds
  tags = {
    owner       = "platform"
    environment = var.environment
    cost-center = "engineering"
    application = "dashboard-counting-stack"
  }
}
