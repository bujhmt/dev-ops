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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDakFPaE4Zn+JjNUlMfdNv+aLuT0LFmb5Os0hc1Mo+3EwyHki/zXC3LIv4gA0p4fU2goEzUE+EWpTUWG2vlp8dJwYSKZPRHDJ1JPhdAnPXTu2WwT9KdKtewSfxM7NQP4ujAfGuxwyN0lj9f5DSJRRoA78dK2xq7QKa5SwVEUxyQQk5gkFk4mUwuY75bhOENduTV6AFNzH40yWhWzeLeXsjYhUGA6CfEXlOklQOXhTbkA1vn2+ODjImSt3Ah2rfhU2g49W/JF9X8OMIHIWtEG60xrzKAGGrd91BeWt+Xrb0UyAzo/5/cLcTWTm7T0CQwv7+BhpE3bATvQsfUIKKWo+1lcm5AbmcZJYwhDBeL+C9xkhm/Jaj9Sv2831jGwe3XDEfesKxAmobe/XITA9COav6GTVPmUToVr5Gl5BStGr0ZehFhjQkxCwlfoezkDKD7vaFUJ0NcK9vhyTU8nHux/7Ebv9hw2t4nBQvJsR2pOnFf5q6SV7TVf1ixT3YyiJW9dXiGEJPVEkw713Xl9iwMExl+Uu+0WJeQN0U1ong9EVomksUxnxRd1Fr088xnGLuyxO3dDy2/kG2/HTBFeX+K0WoE7x0e00HJlvIM2CTxkmn6x3V/0qlVfh+GMzKe0nJwwrGKcakPrI+P91pPDyHAwBRcsW755m2tYhU94M2E24Nr8Q== ihor@MacBook-Pro.local"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "my-jenkins-sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["94.45.53.204/32"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["94.45.53.204/32"]
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