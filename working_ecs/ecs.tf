resource "aws_ecs_cluster" "acme-ecs-cluster" {
  name = "acme-ecs-cluster"
}

resource "aws_ecs_task_definition" "acme-ecs-task" {
  family = "acme-ecs-task"
  container_definitions = <<EOF
[
  {
    "name": "acme-licensing",
    "image": "${var.ecs_container_image_tag}",
    "networkMode": "bridge",
    "cpu": ${var.ecs_container_cpu},
    "memory": ${var.ecs_container_mem},
    "portMappings": [
        {
          "containerPort": ${var.ecs_container_port},
          "protocol": "tcp"
        }
      ],
    "placementStrategy": [
      {
        "field": "attribute:ecs.availability-zone",
        "type": "spread"
      }
      ],
    "environment": [
       { "name" : "LIC_DURATION_DAYS", "value" : "${var.env_lic_duration_days}" }
      ]
}
]
EOF
}

resource "aws_ecs_service" "acme-service-ecs" {
  name            = "acme-service-ecs"
  cluster         = "${aws_ecs_cluster.acme-ecs-cluster.name}"
  task_definition = "${aws_ecs_task_definition.acme-ecs-task.arn}"

  desired_count = "${var.ecs_desired_count}"
  load_balancer {
    target_group_arn = "${aws_alb_target_group.acme-lb-targetgroup.arn}"
    container_name = "${var.ecs_container_name}"
    container_port = "${var.ecs_container_port}"
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 50
}
