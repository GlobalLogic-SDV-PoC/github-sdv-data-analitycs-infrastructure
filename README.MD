# IAM Role for GitHub Actions OIDC Access

This Terraform module provisions an AWS IAM Role that allows GitHub Actions workflows from the `github-sdv-poc-msp-ipc` repository to assume the role using OpenID Connect (OIDC) without static AWS credentials.

## Prerequisites

- Terraform >= 1.0
- AWS CLI with credentials that allow IAM role and S3 creation
- An existing OIDC provider for `token.actions.githubusercontent.com` in your AWS account

## Files

- `main.tf`: Defines the IAM role, S3 bucket, and policy
- `variables.tf`: Contains required input variables
- `README.md`: This file

## Usage

```bash
cd infrastructure/terraform/

terraform init
terraform plan -var="aws_account_id=203647640528"
terraform apply -var="aws_account_id=203647640528"
