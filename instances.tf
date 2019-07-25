resource "aws_instance" "jenkins-master" {
  # ami = "${lookup(var.amis, var.aws_region)}"
  # instance_type = "t2.small"
  subnet_id = "${aws_subnet.main-public-1.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_securitygroup.id}"]
  key_name = "${aws_key_pair.mykeypair.key_name}"

}
