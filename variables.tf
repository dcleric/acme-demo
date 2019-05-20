data "template_file" "user_data" {
  template = "${file("templates/user_data.sh")}"

  vars {
    cluster_name = "${var.ecs_cluster_name}"
  }
}

variable "ecs_cluster_name" {
  default = "acme-licensing-ecs-cluster"
}
variable "name" {
  default = "acme-licensing"
}

variable "cidr" {
  default = "10.0.0.0/16"
}
variable "environment" {
  default = "production"
}

variable "private_subnet_cidr" {
  default = "10.0.1.0/24"
}
variable "public_subnet_cidr" {
  default = "10.0.2.0/24"
}
variable "availability_zone" {
  default = "eu-central-1a"
}
