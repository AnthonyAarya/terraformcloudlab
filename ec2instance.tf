provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "EC2Instance" {
  ami           = "ami-0f99c1965355b1274"
  instance_type = "t2.micro"  

  tags = {
    Name = "MyEC2Instance"
  }
}
