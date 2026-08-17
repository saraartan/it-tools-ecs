resource "aws_iam_role_policy" "github_actions_state" {
  name = "${var.project_name}-github-actions-state-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::it-tools-terraform-state-712607540523",
          "arn:aws:s3:::it-tools-terraform-state-712607540523/*"
        ]
      }
    ]
  })
}
