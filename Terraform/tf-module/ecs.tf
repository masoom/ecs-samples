resource "aws_ecs_cluster" "this" {
  name = var.name
}

resource "random_id" "app_key" {
  byte_length = 32
}

resource "aws_ecs_task_definition" "this" {
  family = var.name
  container_definitions = templatefile("${path.module}/task_definition.json.tpl", {
    image          = var.image
    image_tag      = var.tag
    cpu            = 256
    memory         = 512
    service_name   = var.name
    containerPort  = var.container_port
    stopTimeout    = 30
    aws_region     = data.aws_region.current.name
    logGroup       = var.name
  })
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = aws_ecs_cluster.this.name
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 120

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  # depends_on = [aws_lb_listener.http, aws_lb_listener.https]
}

resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = 7

  tags = {
    Application = var.name
  }
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name                 = "${var.name}-ecs-task-execution-role"
  assume_role_policy   = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name}-ecs-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.copyrightapi_lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
