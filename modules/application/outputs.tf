output "bastion_public_ip" {
  description = "Public IP of the bastion host."
  value       = aws_instance.bastion.public_ip
}

output "dashboard_alb_dns" {
  description = "DNS name of the public dashboard ALB."
  value       = aws_lb.dashboard.dns_name
}

output "counting_alb_dns" {
  description = "DNS name of the private counting ALB."
  value       = aws_lb.counting.dns_name
}
