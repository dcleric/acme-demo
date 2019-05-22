resource "aws_lb" "acme-loadbalancer" {
  name               = "acme-loadbalancer-${var.aws_region}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.load-balancer-sg.id}"]
  subnets            = ["${data.aws_subnet_ids.vpc_subnet_ids.ids}"]
}

resource "aws_security_group" "load-balancer-sg" {
  name        = "load-balancer-sg"
  description = "Loadbalancer security group"
  vpc_id      = "${aws_vpc.vpc.id}"
}

resource "aws_security_group_rule" "inbound_lb_access" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.load-balancer-sg.id}"
}

resource "aws_security_group_rule" "outbound_lb_access" {
  type              = "egress"
  to_port           = 0
  from_port         = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.load-balancer-sg.id}"
}

resource "aws_alb_target_group" "acme-lb-targetgroup" {
  name     = "acme-lb-targetgroup-${var.aws_region}"
  protocol = "HTTP"
  port     = "80"
  vpc_id   = "${aws_vpc.vpc.id}"

  depends_on = [
    "aws_lb.acme-loadbalancer",
  ]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_lb.acme-loadbalancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.acme-lb-targetgroup.id}"
    type             = "forward"
  }
}
