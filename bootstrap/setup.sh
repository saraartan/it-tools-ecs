#!/bin/bash
set -e

echo "=== Bootstrap: one-time setup before Terraform can run ==="

AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
STATE_BUCKET="it-tools-terraform-state-${ACCOUNT_ID}"

echo "Account: $ACCOUNT_ID"
echo "Region: $AWS_REGION"

# 1. Create S3 bucket for Terraform remote state
if aws s3api head-bucket --bucket "$STATE_BUCKET" 2>/dev/null; then
  echo "S3 state bucket already exists: $STATE_BUCKET"
else
  echo "Creating S3 state bucket: $STATE_BUCKET"
  aws s3api create-bucket --bucket "$STATE_BUCKET" --region "$AWS_REGION"
  aws s3api put-bucket-versioning --bucket "$STATE_BUCKET" --versioning-configuration Status=Enabled
fi

# 2. Create ECR repository
if aws ecr describe-repositories --repository-names it-tools --region "$AWS_REGION" >/dev/null 2>&1; then
  echo "ECR repository already exists: it-tools"
else
  echo "Creating ECR repository: it-tools"
  aws ecr create-repository \
    --repository-name it-tools \
    --image-scanning-configuration scanOnPush=true \
    --region "$AWS_REGION"
fi

echo ""
echo "=== Bootstrap complete ==="
echo "State bucket: $STATE_BUCKET"
echo "ECR repository: it-tools"
echo ""
echo "Next steps:"
echo "1. Update terraform/backend.tf with the bucket name above (if different)"
echo "2. Create terraform/terraform.tfvars with hosted_zone_id and container_image"
echo "3. cd terraform && terraform init && terraform apply"
echo "4. The OIDC provider and GitHub Actions IAM role are created BY Terraform"
echo "   itself (see terraform/github-oidc.tf) on first apply -- no separate"
echo "   manual step needed for that part."
