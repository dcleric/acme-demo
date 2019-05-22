output "iam_ecs_profile" {
  value = "${aws_iam_instance_profile.ecs_instance_profile.id}"
}