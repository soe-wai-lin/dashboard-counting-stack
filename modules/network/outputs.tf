output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "data_subnet_ids" {
  description = "Data subnet IDs."
  value       = aws_subnet.data[*].id
}

output "nat_gateway_id" {
  description = "The NAT gateway ID used by private subnets."
  value       = aws_nat_gateway.this.id
}
