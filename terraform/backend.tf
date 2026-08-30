terraform {
  backend "s3" {
    bucket         = "it-tools-terraform-state-712607540523"
    key            = "it-tools/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "it-tools-terraform-lock"
    encrypt        = true
  }
}
