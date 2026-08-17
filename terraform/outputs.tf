output "app_url" {
  description = "The live URL of the application"
  value       = "https://${var.domain_name}"
}

output "alb_dns_name" {
  description = "The ALB's own DNS name"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}
