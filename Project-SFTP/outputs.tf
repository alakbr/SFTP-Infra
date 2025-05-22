output "all_subnet_ids" {
  value = data.aws_subnets.all_subnets.ids
}

output "subnet_ids" {
  description = "List of subnet IDs fetched for the selected VPC."
  value       = data.aws_subnets.all_subnets.ids
}

output "vpc_id" {
  description = "The ID of the selected VPC."
  value       = data.aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the selected VPC."
  value       = data.aws_vpc.vpc.cidr_block
}