data "template_file" "user_data" {
  template = "${file("working_ecs/templates/user_data.sh")}"

  vars {
    cluster_name = "${var.ecs_cluster_name}"
  }
}

data "aws_subnet_ids" "vpc_subnet_ids" {
  vpc_id = "${aws_vpc.vpc.id}"

  depends_on = [
    "aws_subnet.private_subnet",
  ]
}

variable "aws_region" {
  default = "eu-central-1"
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
  type    = "list"
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  type    = "list"
  default = ["eu-central-1a", "eu-central-1b"]
}

# License duration environment variable
variable "env_lic_duration_days" {
  default = "365"
}

# EC2
variable "ec2_key_name" {
  default = "ecs-key"
}

variable "ec2_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrf9ROR2h7JR09tSWav8YT9uQ2N/HHB92vWPay6D90N9kR/j8W2/5rVd8MPaYQwJxAMQgU6qyhnWefKPVCYqxHD2EFWNR23yPdkCeA9V4SWq7xKnHABU8hM6lF6Wd+ptRb6MsBBLqLE/x4svh3DKkLIPMrVao+pzhjT9PzzSG1u2VfTQBaPZKtxWrOltObYoatXJoRPfe1qJIbsQypUZQt5CnnsjAgQlvh3GTgiunUgPVViJ6PxjpQrYrwErS82TIHZCttDhffeXP/o91uvcjr0nkGRzNN1CSKy8L5YmI/BlwaFahnuIeQpBQ7BquRi5CZ9WzM040ZdazLrhDtyrET ecs@aws.key"
}

variable "ec2_flavor" {
  default = "t2.micro"
}

variable "ec2_image_name" {
  default = "ami-06a20f16dd2f50741"
}

variable "ec2_root_volume" {
  default = "8"
}

## Autoscaling group sizes
variable "ec2_asg_min_size" {
  default = 2
}

variable "ec2_asg_max_size" {
  default = 4
}

# ECS Number of tasks
variable "ecs_desired_count" {
  default = 2
}

variable "ecs_container_name" {
  default = "acme-licensing"
}

variable "ecs_container_cpu" {
  default = 0
}

variable "ecs_container_mem" {
  default = 128
}

variable "ecs_container_port" {
  default = 80
}

variable "ecs_container_image_tag" {
  default = "nginx:alpine"
}

variable "iam_ecs_profile" {
  default = "profile"
}
