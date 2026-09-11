resource "aws_security_group" "sg_alb" {
  vpc_id = aws_vpc.vpc.id
  name   = "sgalb-${var.region_name}"
}
#ingress
resource "aws_security_group_rule" "sg_alb_ingress_port_80" {
  security_group_id = aws_security_group.sg_alb.id
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  type              = "ingress"
  from_port         = 80
  to_port           = 80
}
resource "aws_security_group_rule" "sg_alb_ingress_port_443" {
  security_group_id = aws_security_group.sg_alb.id
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  type              = "ingress"
  from_port         = 443
  to_port           = 443
}
#egress
resource "aws_security_group_rule" "sg_alb_egress" {
  security_group_id = aws_security_group.sg_alb.id
  cidr_blocks = ["0.0.0.0/0"]

  protocol          = "-1"
  type              = "egress"
  from_port         = 0
  to_port           = 0
}