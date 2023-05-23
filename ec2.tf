# ec2 
resource "aws_instance" "terra-ec2" {
  ami                     = "var.aws_ami.id"
  instance_type           = "var.instance_type"
  subnet_id = aws_subnet.terra-sub-a.id
  key_name = "hyd"
  vpc_security_group_ids = [aws_security_group.sg-0fe6c5fd56c0db9de.id]
  user_data = file("services.sh")

  tags = {
    Name = "terra.ec2"
  }
}
# custom launch config
resource "aws_launch_configuration" "terra-ec2" {
  name          = "terra-ec2"
  image_id      = data.aws_ami.var.image_id.id
  instance_type = "var.instance_type"
  key_name = "hyd"
}
# auto scaling groups
resource "aws_autoscaling_group" "terra_auto" {
  name                      = "terra_auto"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "EC2"
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.terra-ec2.name
  vpc_zone_identifier       = [aws_subnet.terra-sub-a.id, aws_subnet.terra-sub-b.id]
}
# auto scaling policies
  resource "aws_autoscaling_policy" "terra_pol" {
  name                   = "terra_pol"
  scaling_adjustment     = var.scaling_adjustment
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.terra_auto.name
}

# cloud watch alarm
resource "aws_cloudwatch_metric_alarm" "terra_alarm" {
  alarm_name          = "terra_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terra_auto.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.bat.arn]
}
# auto descaling policy
resource "aws_autoscaling_policy" "terra_pol1" {
  name                   = "terra_pol1"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.terra_auto.name
}
# descaling cloud alarm
resource "aws_cloudwatch_metric_alarm" "terra_alarm1" {
  alarm_name          = "terra_alarm1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terra_auto.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.bat.arn]
}