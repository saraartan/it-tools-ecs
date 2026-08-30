resource "aws_dynamodb_table" "terraform_lock" {
  name         = "it-tools-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "it-tools-terraform-lock"
    Purpose = "Terraform state locking"
  }
}
