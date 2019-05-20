resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Environment = "${var.environment}"
  }
}
resource "aws_subnet" "private_subnet"{
  vpc_id             = "${aws_vpc.vpc.id}"
  cidr_block         = "${var.private_subnet_cidr}"
  availability_zone = "${var.availability_zone}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet"{
  vpc_id             = "${aws_vpc.vpc.id}"
  cidr_block         = "${var.public_subnet_cidr}"
  availability_zone = "${var.availability_zone}"
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

}

resource "aws_route" "route" {
  route_table_id            = "${aws_route_table.route_table.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.vpc.id}"
}

resource "aws_route_table_association" "subnet" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

