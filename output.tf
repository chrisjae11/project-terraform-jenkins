output "private_ip" {
  value = "${aws_instance.jenkins_master.private_ip}"
}

output "public_ip"  {
  value = "${aws_instance.jenkins_master.public_ip}"
}
