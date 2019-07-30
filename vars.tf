
variable "aws_access_key" {}

variable "aws_secret_key" {}



variable "aws_region" {
  default = "us-west-2"
}

variable "private_key" {
  default = "mykey"
}

variable "public_key" {
  default = "mykey.pub"
}

variable "amis" {
  type = "map"

  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "instance_device_name" {
  default = "/dev/xvdh"
}

//

variable "jenkins_username" {
  description = "Jenkins username"
}

variable "jenkins_password" {
  description = "Jenkins password"
}

variable "jenkins_credentials_id" {
  description = "jenkins-slaves"
}


variable "jenkins_slave_instance_type" {
  description = "Jenkins Slave instance type"
  default     = "t2.micro"
}

variable "min_jenkins_slaves" {
  description = "Min slaves"
  default     = "1"
}

variable "max_jenkins_slaves" {
  description = "Max slaves"
  default     = "5"
}
