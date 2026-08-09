output "instance_ids" {
  value = aws_instance.main[*].id
}

output "instance_public_ips" {
  value = aws_instance.main[*].public_ip
}

output "instance_private_ips" {
  value = aws_instance.main[*].private_ip
}

output "network_interface_ids" {
  value = aws_instance.main[*].primary_network_interface_id
}

output "iam_role_name" {
  value = aws_iam_role.ec2_role.name
}