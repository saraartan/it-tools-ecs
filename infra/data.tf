data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_acm_certificate" "cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}
