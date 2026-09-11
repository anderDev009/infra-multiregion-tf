resource "aws_lb" "app" {
 name = "alb-app-${var.region_name}"
 internal = false
 load_balancer_type = "application"
 security_groups = [aws_security_group.sg_alb.id]
 subnets = [for subnet in aws_subnet.public : subnet.id]
}
#target group
resource "aws_lb_target_group" "app" {
  name = "alb-app-tg-${var.region_name}"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id
  
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
    matcher             = "200"
  }
}
#listener
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}