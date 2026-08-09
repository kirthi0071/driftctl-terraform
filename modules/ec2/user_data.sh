#!/bin/bash
set -e

echo "=== Initializing ${instance_name} ===" >> /var/log/user-data.log

# Update system
yum update -y >> /var/log/user-data.log 2>&1

# Install essential packages
yum install -y \
  curl \
  wget \
  git \
  htop \
  vim \
  net-tools >> /var/log/user-data.log 2>&1

# Create marker file
echo "Instance ${instance_name} initialized at $(date)" > /tmp/instance_initialized.txt

echo "=== Initialization complete ===" >> /var/log/user-data.log
