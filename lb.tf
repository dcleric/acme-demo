resource "aws_alb" "acme-loadbalancer" {
  name = "acme-loadbalancer"
  internal = false
  security_groups = []
  subnets = ["${aws_subnet.private_subnet.id}"]
}

resource "aws_security_group" "load-balancer-sg" {
  name        = "${var.name}"
  description = "Loadbalancer security group"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Environment   = "${var.environment}"
  }
}

resource "aws_security_group_rule" "inbound_lb_access" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.load-balancer-sg.id}"
}

resource "aws_alb_target_group" "acme-lb-targetgroup" {
  name = "acme-lb-targetgroup"
  protocol = "HTTP"
  port = "80"
  vpc_id = "${aws_vpc.vpc.id}"
}


resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.acme-loadbalancer.id}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.acme-lb-targetgroup.id}"
    type             = "forward"
  }
}