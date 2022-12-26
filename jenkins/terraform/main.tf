terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-central-1"
  profile = "private"
}

resource "aws_key_pair" "deployer" {
  key_name   = "tf-key"
  public_key = "ssh-rsa <public-ssh-key>"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "my-jenkins-sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["my-ip"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["ip"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-jenkins-sg"
    CreatedBy = "terraform"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  key_name      = "tf-key"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "ExampleAppServerInstance"
  }

  user_data = <<EOF
#!/bin/bash
sudo yum -y install docker
sudo usermod -a -G docker ec2-user
id ec2-user
newgrp docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

docker run --name jenkins -p 80:8080 -d -v /your/home:/var/jenkins_home jenkins/jenkins
EOF
}
