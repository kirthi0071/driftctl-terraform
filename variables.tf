variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "kirthi-drift-demo"
}

# VPC Module Variables
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "kirthi-drift-vpc"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# Security Group Module Variables
variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = "kirthi-drift-sg"
}

variable "security_group_description" {
  description = "Security group description"
  type        = string
  default     = "Security group for drift detection demo"
}

# EC2 Module Variables
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "instance_name" {
  description = "Name of EC2 instance"
  type        = string
  default     = "kirthi-drift-demo-instance"
}

variable "enable_public_ip" {
  description = "Enable public IP for EC2 instance"
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default = {
    Terraform = "true"
    DriftDemo = "true"
    CreatedBy = "kirthi"
  }
}
