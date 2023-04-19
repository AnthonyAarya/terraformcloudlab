variable "region" {
  type    = string
  default = "us-east-1"
}
variable "ingress_ports" {
  type    = list(number)
  default = [22, 8080]
}
variable "instance_type" {
  type = map(any)
  default = {
    "us-east-1a" = "t2.micro"
    "us-east-1b" = "t2.medium"
    "us-east-1c" = "t2.large"
  }
}
variable "az" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

