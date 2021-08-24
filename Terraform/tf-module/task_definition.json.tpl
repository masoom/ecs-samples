[
  {
    "name": "${service_name}",
    "image": "${image}:${image_tag}",
    "essential": true,
    "cpu": ${cpu},
    "memory": ${memory},
    "stopTimeout": ${stopTimeout},
    "portMappings": [
      {
        "containerPort": ${containerPort},
        "hostPort": ${containerPort}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${logGroup}",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "prefix"
      }
    },
    "environment": [
      {
          "name": "APP_DEBUG",
          "value": "false"
      },
      {
          "name": "SESSION_DOMAIN",
          "value": "${SESSION_DOMAIN}"
      }
    ]
  }
]
