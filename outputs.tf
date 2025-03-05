output "aws_region" {
  value = "us-east-1"
}

output "alb_dns_endpoint" {
  description = "The DNS name of the ALB"
  value       = module.alb.alb_dns_name
  #  value       = module.load_balancer.lb_dns_name
}

output "efs_id" {
  value = module.efs.efs_id
}