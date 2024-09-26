#!/bin/bash
# Bootstrap script to install Docker and other prerequisites

sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -aG docker ec2-user
