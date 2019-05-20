
#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER="acme-ecs-cluster""
} >> /etc/ecs/ecs.config

start ecs

echo "Done"