output "private_ip" {
  value = "${aws_instance.jenkins_master.private_ip}"
}

output "public_ip"  {
  value = "${aws_instance.jenkins_master.public_ip}"
}

output "jenkins dns" {
  value = "https://${aws_route53_record.jenkins_master.name}"
}
