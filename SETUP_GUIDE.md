# Terraform Drift Detection Platform on AWS

[![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![driftctl](https://img.shields.io/badge/Drift%20Detection-driftctl-00C7B7)](https://github.com/snyk/driftctl)

A production-ready Terraform infrastructure project that provisions AWS resources using a **modular architecture** and continuously monitors infrastructure drift using **driftctl**, **GitHub Actions**, and **AWS-native monitoring**. The platform demonstrates how infrastructure changes made outside Terraform are automatically detected, reported, and operationalized through scheduled scans and alerting workflows.

---

## Table of Contents

- [Overview](#overview)
- [Key Capabilities](#key-capabilities)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Technologies](#technologies)
- [Infrastructure Components](#infrastructure-components)
- [Remote State Management](#remote-state-management)
- [Deployment](#deployment)
- [Drift Detection Workflow](#drift-detection-workflow)
- [Production Automation](#production-automation)
- [Enterprise Monitoring Architecture](#enterprise-monitoring-architecture)
- [Operational Workflow](#operational-workflow)
- [Remediation Options](#remediation-options)
- [CI/CD Integration](#cicd-integration)
- [Security Best Practices](#security-best-practices)
- [Multi-Environment Support](#multi-environment-support)
- [Sample Drift Report](#sample-drift-report)
- [Resume Impact](#resume-impact)
- [Future Enhancements](#future-enhancements)
- [Author](#author)

---

## Overview

Infrastructure drift occurs when cloud resources are modified manually through the AWS Console, CLI, SDKs, or other automation tools — without a corresponding change in Terraform. This project implements a complete drift detection workflow that compares the Terraform state with the actual AWS environment and reports any configuration differences.

## Key Capabilities

| Capability | Description |
|---|---|
| **Modular Terraform architecture** | Separate modules for VPC, EC2, Security Groups, IAM, and networking |
| **Remote state** | S3 backend with DynamoDB state locking |
| **Automated drift detection** | Powered by `driftctl` |
| **Scheduled scans** | GitHub Actions workflows on a cron schedule |
| **Alerting** | Slack / Teams alert integration |
| **Near real-time monitoring** | CloudTrail + EventBridge support |
| **Multi-environment support** | Independent `dev` / `prod` deployments from shared modules |

## Architecture

```
GitHub Repository
        │
        ▼
GitHub Actions (Scheduled)
        │
        ▼
Terraform State (S3)
        │
        ▼
driftctl Scan Engine
        │
        ▼
AWS Infrastructure
        │
        ▼
Slack / Teams / Email Alerts
```

The platform periodically compares the Terraform state file with live AWS infrastructure and generates drift reports highlighting missing resources, attribute changes, and tag changes.

## Project Structure

```
terraform-drift-demo/
├── backend.tf
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── vpc/
│   ├── security_group/
│   └── ec2/
├── env/
│   └── dev/
│       └── dev.tfvars
├── .github/
│   └── workflows/
│       └── drift-detection.yml
└── README.md
```

## Technologies

- Terraform
- AWS (VPC, EC2, IAM, Security Groups, NAT Gateway)
- Amazon S3
- Amazon DynamoDB
- GitHub Actions
- driftctl
- AWS CloudTrail
- Amazon EventBridge
- Amazon SNS

## Infrastructure Components

### Networking
- Custom VPC
- Public and private subnets
- Internet Gateway
- NAT Gateway
- Route tables and route table associations

### Compute
- Amazon EC2
- IAM instance profile
- Amazon SSM integration
- Encrypted GP3 root volumes

### Security
- Modular security group management
- Least-privilege IAM roles
- SSM Session Manager instead of SSH dependency
- Encrypted storage

## Remote State Management

Terraform state is stored remotely in Amazon S3 with DynamoDB state locking.

**Benefits:**
- Team collaboration
- State consistency
- Concurrent execution protection
- Versioned state history
- Disaster recovery support

**Example backend configuration:**

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "drift-demo/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

## Deployment

```bash
# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan -var-file=env/dev/dev.tfvars

# Apply
terraform apply -var-file=env/dev/dev.tfvars
```

## Drift Detection Workflow

### Manual Validation

Pull the latest Terraform state:

```bash
terraform state pull > terraform.tfstate
```

Run driftctl:

```bash
./bin/driftctl scan \
  --state terraform.tfstate \
  --provider aws \
  --region ap-south-1
```

### Example Drift

Terraform expects:

```
Name = kirthi-drift-demo-instance
```

AWS actual value:

```
Name = kirthi-drift-demo-instances
```

driftctl reports:

```
tags_changed
Resource: aws_instance
Field: tags.Name
Expected: kirthi-drift-demo-instance
Actual:   kirthi-drift-demo-instances
```

## Production Automation

In production, drift detection should never rely on engineers manually running commands from a local machine or VS Code.

### Scheduled GitHub Actions

```yaml
name: Terraform Drift Detection

on:
  schedule:
    - cron: '*/15 * * * *'

jobs:
  drift:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Terraform Init
        run: terraform init

      - name: Pull State
        run: terraform state pull > terraform.tfstate

      - name: Run driftctl
        run: |
          ./bin/driftctl scan \
            --state terraform.tfstate \
            --provider aws \
            --region ap-south-1
```

This executes automatically every 15 minutes and can be integrated with Slack or Microsoft Teams.

## Enterprise Monitoring Architecture

For near real-time drift detection:

```
AWS Console / CLI
        │
        ▼
CloudTrail
        │
        ▼
EventBridge
        │
        ▼
Lambda
        │
        ▼
SNS / Slack / Teams
```

When an infrastructure change occurs, CloudTrail records the API event, EventBridge triggers a Lambda function, and the system immediately generates a drift alert.

## Operational Workflow

1. Infrastructure modified outside Terraform
2. CloudTrail records the event
3. Scheduled drift scan executes
4. driftctl compares state with AWS
5. Drift report generated
6. Slack/Teams notification sent
7. Incident ticket created if required

## Remediation Options

**Option 1: Restore desired state**

```bash
terraform apply
```

**Option 2: Accept the change**

Update the Terraform configuration to reflect the manual change, then apply:

```bash
terraform apply -var-file=env/dev/dev.tfvars
```

## CI/CD Integration

A production implementation should include:

- Pull request validation (`terraform fmt`, `terraform validate`, `terraform plan`)
- Security scanning
- Drift detection
- Approval gates
- Automated reporting

## Security Best Practices

- IAM least privilege
- Encrypted S3 backend
- DynamoDB state locking
- Encrypted EBS volumes
- SSM Session Manager
- Versioned state files
- CloudTrail audit logging
- Remote state access control

## Multi-Environment Support

The same modules can be deployed across environments — only the `.tfvars` file changes.

```bash
# Development
terraform apply -var-file=env/dev/dev.tfvars

# Production
terraform apply -var-file=env/prod/prod.tfvars
```

Environment-specific values are isolated from reusable infrastructure modules.

## Sample Drift Report

```
SUMMARY

Total Resources:    39
Missing in Cloud:   0
Extra in Cloud:     0
Attribute Changes:  0
Tag Changes:        1

FINDINGS

tags_changed
Resource: aws_instance
Field: tags.Name
Expected: kirthi-drift-demo-instance
Actual:   kirthi-drift-demo-instances
```

## Resume Impact

This project demonstrates practical, hands-on experience with:

- Terraform modular architecture
- AWS networking
- Remote state management
- Infrastructure drift detection
- GitHub Actions automation
- Infrastructure governance
- Cloud compliance monitoring
- DevOps operational workflows

## Future Enhancements

- [ ] Terraform Cloud integration
- [ ] AWS Config compliance rules
- [ ] Security Hub integration
- [ ] Prometheus metrics export
- [ ] Grafana drift dashboards
- [ ] Jira Service Management integration
- [ ] Auto-remediation workflows
- [ ] Multi-account AWS Organizations support

## Author

**Kirthi Kumar**
Terraform • AWS • DevOps • Infrastructure Automation • Cloud Operations