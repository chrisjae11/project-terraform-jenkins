resource "aws_launch_configuration" "jenkins_slave_launch_conf" {
  name            = "jenkins_slave_config"
  image_id        = "${data.aws_ami.jenkins-slave.id}"
  instance_type   = "${var.jenkins_slave_instance_type}"
  key_name        = "${aws_key_pair.mykeypair.key_name}"
  security_groups = "${aws_security_group.jenkins_slave_sg.id}"
  user_data       = "${data.template_file.user_data_slave.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "jenkins_slaves" {
  name                 = "jenkins_slaves_asg"
  launch_configuration = "${aws_launch_configuration.jenkins_slaves_launch_conf.name}"
  vpc_zone_identifier  = "${aws_subnet.main-private-1}"
  min_size             = "${var.min_jenkins_slaves}"
  max_size             = "${var.max_jenkins_slaves}"

  depends_on = ["aws_instances.jenkins_master", "aws_elb.jenkins_elb"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "jenkins_slaves"
    propagate_at_launch = true
  }
}


resource "aws_cloudwatch_metric_alarm" "high-cpu-jenkins-slaves-alarm" {
  alarm_name           = "high-cpu-jenkins-slaves-alarm"
  comparision_operator = "GreateThanOrEqualToThreshold"
  evaulation_periods   = "2"
  metric_name          = "CPUUtilization"
  namespace            = "AWS/EC2"
  statistic            = "Average"
  threshoold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.jenkins_slaves.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale-out.arn}"]
}

resource "aws_autoscaling_policy" "scale-out" {
  name                   = "scale-out-jenkins-slaves"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.jenkins_slaves.name}"
}

resource "aws_cloudwatch_metric_alarm" "low-cpu-jenkins-slaves-alarm" {
  alarm_name          = "low-cpu-jenkins-slaves-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimenstions {
    AutoScalingGroupName = "${aws_autoscaling_group.heavy.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale-in.arn}"]

}

resource "aws_autoscaling_policy" "scale-in" {
  name                   = "scale-in-jenkins-slaves"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.jenkins_slaves.name}"
}
