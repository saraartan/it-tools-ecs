# Bootstrap

One-time setup required before Terraform can run for the first time.

## What this creates

- **S3 bucket** for Terraform's remote state (so state is shared between your
  local machine and GitHub Actions, not just stored locally)
- **ECR repository** to hold the Docker image, with vulnerability scanning
  enabled on push

## What this does NOT create

The OIDC provider and the GitHub Actions IAM role are created **by Terraform
itself** (`terraform/github-oidc.tf`) on the first `terraform apply` — not by
this script. This is intentional: those resources are meant to live in code
and be version-controlled like everything else, not created as a one-off
manual step.

## Usage

```bash
chmod +x setup.sh
./setup.sh
```

Requires AWS CLI configured with credentials that can create S3 buckets and
ECR repositories.

## After running this

1. Confirm/update the bucket name in `terraform/backend.tf`
2. Create `terraform/terraform.tfvars`:
3. `cd terraform && terraform init && terraform apply`
