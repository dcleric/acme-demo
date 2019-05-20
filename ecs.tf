resource "aws_ecs_cluster" "acme-ecs-cluster" {
  name = "acme-ecs-cluster"
}

resource "aws_ecs_task_definition" "acme-ecs-task" {
  family = "acme-ecs-task"
  container_definitions = <<EOF
[
  {
    "name": "acme-licensing",
    "image": "nginx:alpine",
    "cpu": 0,
    "memory": 128,
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp"
        }
      ]
}
]
EOF
}

resource "aws_ecs_service" "acme-service-ecs" {
  name            = "acme-service-ecs"
  cluster         = "${aws_ecs_cluster.acme-ecs-cluster.name}"
  task_definition = "${aws_ecs_task_definition.acme-ecs-task.arn}"

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
