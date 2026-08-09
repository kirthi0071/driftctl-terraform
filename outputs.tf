output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "security_group_id" {
  description = "Security group ID"
  value       = module.security_group.security_group_id
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = module.ec2.instance_ids
}

output "instance_private_ips" {
  description = "Private IPs of EC2 instances"
  value       = module.ec2.instance_private_ips
}

output "instance_public_ips" {
  description = "Public IPs of EC2 instances"
  value       = module.ec2.instance_public_ips
}

output "network_interface_ids" {
  description = "Primary network interface IDs"
  value       = module.ec2.network_interface_ids
}

output "iam_role_name" {
  description = "IAM role name attached to EC2"
  value       = module.ec2.iam_role_name
}

output "connection_info" {
  description = "SSH and SSM connection information"
  value       = <<-EOT

SSH:
ssh -i <your-key-pair.pem> ec2-user@${module.ec2.instance_public_ips[0]}

SSM:
aws ssm start-session --target ${module.ec2.instance_ids[0]} --region ${var.aws_region}

Instance ID: ${module.ec2.instance_ids[0]}
Public IP: ${module.ec2.instance_public_ips[0]}

EOT
}