resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  instance_tenancy     = "default"

  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "my_public_SN" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.az[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "My_Public_Subnet"
  }
}
resource "aws_subnet" "my_private_SN" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az[1]
  tags = {
    Name = "My_Private_Subnet"
  }
}
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "My_Internet_Gateway"
  }
}
resource "aws_route_table" "My_Rt" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "My_Rt"
  }
}
resource "aws_route" "My_r" {
  route_table_id         = aws_route_table.My_Rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Igw.id
}
resource "aws_route_table_association" "My_RTA" {
  route_table_id = aws_route_table.My_Rt.id
  subnet_id      = aws_subnet.my_public_SN.id
}

