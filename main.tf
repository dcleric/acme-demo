
module "iam_roles" {
  source = "./iam_roles"
  providers = {
    aws = "aws.eu"
  }
}

# EU region rollout
module "working_ecs" {
  source = "./working_ecs"
    providers = {
    aws = "aws.eu"
  }
  aws_region = "eu-central-1"
  availability_zones = ["eu-central-1a", "eu-central-1b"]
  iam_ecs_profile = "${module.iam_roles.iam_ecs_profile}"
}

# US region rollout
module "working_ecs_us" {
  source = "./working_ecs"
  providers = {
    aws = "aws.us"
  }
  aws_region = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b"]
  ec2_image_name = "ami-0750ab1027b6314c7"
  iam_ecs_profile = "${module.iam_roles.iam_ecs_profile}"
}

resource "aws_route53_record" "eu-acme-demo" {
  provider = "aws.eu"
  name = "eu-acme-demo.dcleric.xyz"
  type = "A"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  alias {
    evaluate_target_health = true
    name = "${module.working_ecs.aws_lb_dns_name}"
    zone_id = "${module.working_ecs.aws_lb_zone_id}"
  }
}

resource "aws_route53_record" "us-acme-demo" {
  provider = "aws.eu"
  name = "us-acme-demo.dcleric.xyz"
  type = "A"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  alias {
    evaluate_target_health = true
    name = "${module.working_ecs_us.aws_lb_dns_name}"
    zone_id = "${module.working_ecs_us.aws_lb_zone_id}"
  }
}

resource "aws_route53_record" "acme-demo-balanced-eu" {
  provider = "aws.eu"
  name = "acme-demo.dcleric.xyz"
  type = "CNAME"
  ttl = "300"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  set_identifier = "eu-acme-demo-geo-bal"
  records = [ "${aws_route53_record.eu-acme-demo.fqdn}"]
  geolocation_routing_policy {
    continent = "EU"
    country = "*"
  }
}

resource "aws_route53_record" "acme-demo-balanced-us" {
  provider = "aws.eu"
  name = "acme-demo.dcleric.xyz"
  type = "CNAME"
  ttl = "300"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  set_identifier = "us-acme-demo-geo-bal"
  records = [ "${aws_route53_record.us-acme-demo.fqdn}"]
  geolocation_routing_policy {
    continent = "NA"
    country = "*"
  }
}