resource "aws_security_group" "sg_instance" {
  vpc_id = aws_vpc.vpc.id
  name   = "sginstancesEC2-${var.region_name}"

}
#ingress (solo para el sg ALB)
resource "aws_security_group_rule" "sg_instance_ingress_port_80" {
  security_group_id = aws_security_group.sg_instance.id
  type              = "ingress"
  protocol          = "tcp"
  source_security_group_id = aws_security_group.sg_alb.id
  from_port         = 80
  to_port           = 80
}
#egress
resource "aws_security_group_rule" "sg_instance_egress" {
  security_group_id = aws_security_group.sg_instance.id
  cidr_blocks = ["0.0.0.0/0"]
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
}