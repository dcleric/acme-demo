output "aws_lb_dns_name" {
  value = "${aws_lb.acme-loadbalancer.dns_name}"
}

output "aws_lb_zone_id" {
  value = "${aws_lb.acme-loadbalancer.zone_id}"
}