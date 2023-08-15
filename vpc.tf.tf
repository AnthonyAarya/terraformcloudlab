#provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

#vpc

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc"
  }
}

#subnet

resource "aws_subnet" "pubsub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a" 

  tags = {
    Name = "pub-sub"
  }
}

resource "aws_subnet" "pvtsub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "pvt-sub"
  }
}

#RT
resource "aws_route_table" "RTPub" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "My-RTpub"
  }
}

resource "aws_route_table" "RTPvt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT.id
  }

  tags = {
    Name = "My-RTpvt"
  }
}


#IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Internet-Gateway"
  }
}

#RTAS

resource "aws_route_table_association" "rtpubasc" {
  subnet_id      = aws_subnet.pubsub.id
  route_table_id = aws_route_table.RTPub.id
}

resource "aws_route_table_association" "rtpvtasc" {
  subnet_id      = aws_subnet.pvtsub.id
  route_table_id = aws_route_table.RTPvt.id
}


#EIP

resource "aws_eip" "EIP" {
  domain   = "vpc"
}

#NAT

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.pubsub.id

  tags = {
    Name = "Nat-Gw"
  }
}

#SG

resource "aws_security_group" "pubsg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "pub-sg"
  }
}

#Ec2 server

#webserver

resource "aws_instance" "webserver" {
  ami           = "ami-0f99c1965355b1274"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.pubsg.id]
  subnet_id = aws_subnet.pubsub.id

  tags = {
    Name = "Webserver"
  }
}

#appserver

resource "aws_instance" "appserver" {
  ami           = "ami-0f99c1965355b1274"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.pubsg.id]
  subnet_id = aws_subnet.pvtsub.id

  tags = {
    Name = "Appserver"
  }
}