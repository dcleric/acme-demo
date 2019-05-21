
resource "aws_security_group" "instance" {
  name        = "${var.name}"
  description = "Used in prod"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Environment   = "${var.environment}"
  }
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "inbound_ssh_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "inbound_http_access" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "inbound_lb_to_ecs_access" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.load-balancer-sg.id}"
  security_group_id = "${aws_security_group.instance.id}"
}

resource "aws_launch_configuration" "ecs-launch" {
  name = "${var.name}-ecs-launch"
  key_name = "${var.ec2_key_name}"
  instance_type = "${var.ec2_flavor}"
  image_id = "ami-06a20f16dd2f50741"
  user_data = "${data.template_file.user_data.rendered}"
  security_groups = ["${aws_security_group.instance.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.this.id}"
  root_block_device {
    volume_size = "${var.ec2_root_volume}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "asg-launch" {
  name = "acme-asg"
  max_size = "${var.ec2_asg_max_size}"
  min_size = "${var.ec2_asg_min_size}"

  launch_configuration = "${aws_launch_configuration.ecs-launch.id}"
  vpc_zone_identifier = ["${data.aws_subnet_ids.vpc_subnet_ids.ids}"]
  lifecycle {
    create_before_destroy = true
  }
}