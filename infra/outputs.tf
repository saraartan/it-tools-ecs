output "app_url" {
  description = "The live URL of the application"
  value       = "https://${var.domain_name}"
}

output "alb_dns_name" {
  description = "The ALB's own DNS name"
  value       = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}
