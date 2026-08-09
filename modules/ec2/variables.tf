variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
}

variable "instance_name" {
  description = "Instance name"
  type        = string
}

variable "enable_public_ip" {
  description = "Enable public IP"
  type        = bool
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
