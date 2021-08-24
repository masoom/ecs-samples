resource "aws_lb" "this" {
  name               = var.name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.status_lb.id]
  subnets            = var.private_subnets

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    prefix  = var.name
    enabled = true
  }
}

resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    path                = "/api/v1/ping"
    interval            = 30
    matcher             = "200"
    protocol            = "HTTP"
    port                = var.container_port
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn

  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.this.arn

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  depends_on = [aws_lb_listener.http]

  action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.this.arn

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }

}

resource "aws_lb_listener_rule" "https" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  depends_on = [aws_lb_listener.https]

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }

}

resource "aws_security_group" "status_lb" {
  name        = "${var.name}-load-balancer"
  description = "Allow HTTP traffic to load balancer from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_route53_zone" "this" {
  name         = var.zone
  private_zone = var.private_zone
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    evaluate_target_health = true
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}

