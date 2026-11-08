locals {
  common_tags = merge(
    {
      owner       = "platform"
      environment = var.environment
      cost-center = "engineering"
      application = "dashboard-counting-stack"
    },
    var.tags
  )
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.environment}-bastion-sg"
  description = "Bastion host SSH access"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-bastion-sg"
  })
}

resource "aws_security_group_rule" "bastion_ingress_ssh" {
  type              = "ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_egress_https" {
  type              = "egress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group" "dashboard_lb" {
  name        = "${var.environment}-dashboard-lb-sg"
  description = "Public dashboard ALB ingress"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-dashboard-lb-sg"
  })
}

resource "aws_security_group_rule" "dashboard_lb_ingress_http" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dashboard_lb.id
}

resource "aws_security_group_rule" "dashboard_lb_ingress_https" {
  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dashboard_lb.id
}

resource "aws_security_group_rule" "dashboard_lb_egress_to_dashboard" {
  type                     = "egress"
  from_port                = var.dashboard_tg_port
  to_port                  = var.dashboard_tg_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.dashboard.id
  security_group_id        = aws_security_group.dashboard_lb.id
}

resource "aws_security_group" "counting_lb" {
  name        = "${var.environment}-counting-lb-sg"
  description = "Internal counting ALB ingress"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-counting-lb-sg"
  })
}

resource "aws_security_group_rule" "counting_lb_ingress_http" {
  type                     = "ingress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.dashboard.id
  security_group_id        = aws_security_group.counting_lb.id
}

resource "aws_security_group_rule" "counting_lb_egress_to_counting" {
  type                     = "egress"
  from_port                = var.counting_tg_port
  to_port                  = var.counting_tg_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.counting.id
  security_group_id        = aws_security_group.counting_lb.id
}

resource "aws_security_group" "dashboard" {
  name        = "${var.environment}-dashboard-sg"
  description = "Dashboard service ingress"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-dashboard-sg"
  })
}

resource "aws_security_group_rule" "dashboard_ingress_ssh" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.dashboard.id
}

resource "aws_security_group_rule" "dashboard_ingress_app" {
  type                     = "ingress"
  from_port                = var.dashboard_tg_port
  to_port                  = var.dashboard_tg_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.dashboard_lb.id
  security_group_id        = aws_security_group.dashboard.id
}

resource "aws_security_group_rule" "dashboard_egress_http" {
  type              = "egress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dashboard.id
}

resource "aws_security_group_rule" "dashboard_egress_https" {
  type              = "egress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dashboard.id
}

resource "aws_security_group" "counting" {
  name        = "${var.environment}-counting-sg"
  description = "Counting service ingress"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-counting-sg"
  })
}

resource "aws_security_group_rule" "counting_ingress_ssh" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.counting.id
}

resource "aws_security_group_rule" "counting_ingress_app" {
  type                     = "ingress"
  from_port                = var.counting_tg_port
  to_port                  = var.counting_tg_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.counting_lb.id
  security_group_id        = aws_security_group.counting.id
}

resource "aws_security_group_rule" "counting_egress_https" {
  type              = "egress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.counting.id
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  root_block_device {
    encrypted = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-bastion"
  })
}

resource "aws_lb" "dashboard" {
  name               = "${var.environment}-dashboard-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.dashboard_lb.id]

  tags = merge(local.common_tags, {
    Name = "${var.environment}-dashboard-lb"
  })
}

resource "aws_lb" "counting" {
  name               = "${var.environment}-counting-lb"
  load_balancer_type = "application"
  internal           = true
  subnets            = var.private_subnet_ids
  security_groups    = [aws_security_group.counting_lb.id]

  tags = merge(local.common_tags, {
    Name = "${var.environment}-counting-lb"
  })
}

resource "aws_lb_target_group" "dashboard_pink" {
  name     = "${var.environment}-dashboard-pink"
  port     = var.dashboard_tg_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-dashboard-pink-tg"
  })
}

resource "aws_lb_target_group" "dashboard_green" {
  name     = "${var.environment}-dashboard-green"
  port     = var.dashboard_tg_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-dashboard-green-tg"
  })
}

resource "aws_lb_target_group" "counting" {
  name     = "${var.environment}-counting"
  port     = var.counting_tg_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-counting-tg"
  })
}

resource "aws_lb_listener" "dashboard" {
  load_balancer_arn = aws_lb.dashboard.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.dashboard_pink.arn
        weight = 90
      }
      target_group {
        arn    = aws_lb_target_group.dashboard_green.arn
        weight = 10
      }
    }
  }
}

resource "aws_lb_listener" "counting" {
  load_balancer_arn = aws_lb.counting.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.counting.arn
  }
}

resource "aws_launch_template" "dashboard_pink" {
  name_prefix   = "${var.environment}-dashboard-pink-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.dashboard.id]

  user_data = base64encode(templatefile("${path.module}/templates/dashboard.sh.tpl", {
    counting_alb_dns = aws_lb.counting.dns_name
  }))

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name    = "${var.environment}-dashboard-pink"
      Service = "dashboard"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "dashboard_green" {
  name_prefix   = "${var.environment}-dashboard-green-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.dashboard.id]
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  monitoring {
    enabled = true
  }

  user_data = base64encode(templatefile("${path.module}/templates/dashboard-green.sh.tpl", {
    counting_alb_dns = aws_lb.counting.dns_name
  }))

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name    = "${var.environment}-dashboard-green"
      Service = "dashboard"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "counting" {
  name_prefix   = "${var.environment}-counting-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.counting.id]
   metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  monitoring {
    enabled = true
  }

  user_data = base64encode(file("${path.module}/templates/counting.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name    = "${var.environment}-counting"
      Service = "counting"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dashboard_pink" {
  name                = "${var.environment}-dashboard-pink-asg"
  vpc_zone_identifier = var.private_subnet_ids
  min_size            = var.dashboard_asg_min
  max_size            = var.dashboard_asg_max
  desired_capacity    = var.dashboard_asg_desired_capacity

  target_group_arns = [aws_lb_target_group.dashboard_pink.arn]

  launch_template {
    id      = aws_launch_template.dashboard_pink.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.environment}-dashboard-pink"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "dashboard_green" {
  name                = "${var.environment}-dashboard-green-asg"
  vpc_zone_identifier = var.private_subnet_ids
  min_size            = var.dashboard_asg_min
  max_size            = var.dashboard_asg_max
  desired_capacity    = var.dashboard_asg_desired_capacity

  target_group_arns = [aws_lb_target_group.dashboard_green.arn]

  launch_template {
    id      = aws_launch_template.dashboard_green.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.environment}-dashboard-green"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "counting" {
  name                = "${var.environment}-counting-asg"
  vpc_zone_identifier = var.private_subnet_ids
  min_size            = var.counting_asg_min
  max_size            = var.counting_asg_max
  desired_capacity    = var.counting_asg_desired_capacity

  target_group_arns = [aws_lb_target_group.counting.arn]

  launch_template {
    id      = aws_launch_template.counting.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.environment}-counting"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "dashboard_pink_cpu" {
  name                   = "${var.environment}-dashboard-pink-cpu"
  autoscaling_group_name = aws_autoscaling_group.dashboard_pink.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30
  }
}

resource "aws_autoscaling_policy" "dashboard_green_cpu" {
  name                   = "${var.environment}-dashboard-green-cpu"
  autoscaling_group_name = aws_autoscaling_group.dashboard_green.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30
  }
}

resource "aws_autoscaling_policy" "counting_cpu" {
  name                   = "${var.environment}-counting-cpu"
  autoscaling_group_name = aws_autoscaling_group.counting.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30
  }
}

resource "aws_cloudwatch_metric_alarm" "dashboard_pink_cpu" {
  alarm_name          = "${var.environment}-dashboard-pink-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.alarm_period_seconds
  statistic           = "Average"
  threshold           = var.alarm_threshold_cpu
  alarm_description   = "Alert when dashboard pink ASG CPU exceeds the threshold."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.dashboard_pink.name
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-dashboard-pink-cpu-high"
  })
}

resource "aws_cloudwatch_metric_alarm" "dashboard_green_cpu" {
  alarm_name          = "${var.environment}-dashboard-green-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.alarm_period_seconds
  statistic           = "Average"
  threshold           = var.alarm_threshold_cpu
  alarm_description   = "Alert when dashboard green ASG CPU exceeds the threshold."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.dashboard_green.name
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-dashboard-green-cpu-high"
  })
}

resource "aws_cloudwatch_metric_alarm" "counting_cpu" {
  alarm_name          = "${var.environment}-counting-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.alarm_period_seconds
  statistic           = "Average"
  threshold           = var.alarm_threshold_cpu
  alarm_description   = "Alert when counting ASG CPU exceeds the threshold."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.counting.name
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-counting-cpu-high"
  })
}

resource "aws_route53_record" "dashboard" {
  count = var.route53_zone_id != "" && var.route53_hostname != "" ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.route53_hostname
  type    = "A"

  alias {
    name                   = aws_lb.dashboard.dns_name
    zone_id                = aws_lb.dashboard.zone_id
    evaluate_target_health = true
  }
}
