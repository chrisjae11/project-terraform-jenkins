terraform {
  backend "s3" {
    bucket = "kube8-remote-store"
    key = "jenkins.tfstate"
    region = "us-west-2"
  }
}
