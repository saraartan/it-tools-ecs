# Bootstrap

One-time setup required before the main application infrastructure can be deployed.

## What lives here

Bootstrap is split into two parts:

1. **`setup.sh`** — a script that creates the S3 bucket for Terraform's
   remote state and the ECR repository for the Docker image.
2. **`terraform/`** — a small, separate Terraform configuration that creates
   the GitHub OIDC provider and the IAM role GitHub Actions assumes.

## Why OIDC lives in its own Terraform config, not the main app's

Early in this project, the OIDC provider and GitHub Actions IAM role were
part of the main `terraform/` configuration. This caused a real problem:
running `terraform destroy` on the main config (to tear down the app and
stop paying for the ALB between sessions) also deleted the OIDC trust
relationship, which broke the CI/CD pipeline's ability to authenticate to
AWS at all on the next run.

Moving OIDC into its own bootstrap Terraform config, with its own separate
state file, fixes this: the main app's infrastructure can be destroyed and
recreated freely without ever touching the identity that GitHub Actions
uses to authenticate.

## Usage

**Step 1 — create the state bucket and ECR repo:**

```bash
chmod +x setup.sh
./setup.sh
```

**Step 2 — create the OIDC provider and CI/CD IAM role:**

```bash
cd terraform
terraform init
terraform apply
```

This outputs a `github_actions_role_arn` — add this as a GitHub repository
secret named `AWS_GITHUB_ACTIONS_ROLE_ARN` (Settings → Secrets and variables
→ Actions), which the workflow files reference rather than hardcoding it.

Both steps only need to run once per AWS account, not on every deploy.

## After bootstrap is complete

1. Create `../terraform/terraform.tfvars` with `hosted_zone_id` and
   `container_image`
2. `cd ../terraform && terraform init && terraform apply`
