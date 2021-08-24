# CW Alarm to alert when HealthyHostCount < 2 for 1 datapoints within 5 minutes
resource "aws_cloudwatch_metric_alarm" "unhealthy_host_count" {
  alarm_name          = "${var.name}-healthy-host-count"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 2
  alarm_description   = "This metric alerts when HealthyHostCount < 2"
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]
  datapoints_to_alarm = 1

  dimensions = {
    TargetGroup  = aws_lb_target_group.this.arn_suffix
    LoadBalancer = aws_lb.this.arn_suffix
  }
}



