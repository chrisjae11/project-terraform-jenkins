resource "aws_route53_zone" "primary" {
  name = "${var.domain_name}"   # #### check vars
}

resource "aws_route53_record" "jenkins_master" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name = "jenkins.kube8.io"   ######
  type = "A"

  alias {
    name = "${aws_elb.jenkins_elb.dns_name}"
    zone_id = "${aws_elb.jenkins_elb.zone_id}"
    evalulate_target_health = true
  }
}
