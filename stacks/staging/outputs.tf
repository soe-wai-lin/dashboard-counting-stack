output "dashboard_alb_dns" {
  description = "Public dashboard ALB DNS."
  value       = module.application.dashboard_alb_dns
}

output "counting_alb_dns" {
  description = "Private counting ALB DNS."
  value       = module.application.counting_alb_dns
}

output "bastion_public_ip" {
  description = "Public bastion IP."
  value       = module.application.bastion_public_ip
}
