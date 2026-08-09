output "security_group_id" {
  description = "Security Group ID"
  value       = module.security_group.security_group_id
}

output "security_group_name" {
  description = "Security Group Name"
  value       = module.security_group.security_group_name
}

output "security_group_arn" {
  description = "Security Group ARN"
  value       = module.security_group.security_group_arn
}
