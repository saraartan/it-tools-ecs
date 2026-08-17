module "vpc" {
  source = "./modules/vpc"
}

module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
}

module "alb" {
  source           = "./modules/alb"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.subnet_ids
  certificate_arn  = module.acm.certificate_arn
  container_port   = var.container_port
}

module "ecs" {
  source                 = "./modules/ecs"
  project_name           = var.project_name
  aws_region             = var.aws_region
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.subnet_ids
  container_image        = var.container_image
  container_port         = var.container_port
  alb_security_group_id  = module.alb.alb_security_group_id
  target_group_arn       = module.alb.target_group_arn
}

resource "aws_route53_record" "app" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}
