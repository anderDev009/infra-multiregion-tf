resource "aws_autoscaling_group" "app" {
  desired_capacity = 2
  min_size = 2
  max_size = 4
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns = [aws_lb_target_group.app.arn]

  launch_template {
    id = aws_launch_template.app.id
    version = "$Latest"
  }
}