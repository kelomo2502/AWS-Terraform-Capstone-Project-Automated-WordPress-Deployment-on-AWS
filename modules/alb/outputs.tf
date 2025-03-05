output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "alb_zone_id" {
  value = aws_lb.app_lb.zone_id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}


