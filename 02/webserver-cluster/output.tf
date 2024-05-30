output "alb_dns_name" {
  value = aws_lb.myALB.dns_name
  description = "ALB DNS NAME"
}