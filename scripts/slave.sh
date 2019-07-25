#!/bin/bash

apt -y update
apt -y install java-1.8.0-openjdk.x86_64
/usr/sbin/alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
useradd --home-dir /home/jenkins --create-home --shell /bin/bash jenkins
mkdir /home/jenkins/jenkins-slave
wget https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/{{user `jenkins_version`}}/remoting-{{user `jenkins_version`}}.jar
