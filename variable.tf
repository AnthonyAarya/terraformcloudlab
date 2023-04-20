variable "region" {
  type    = string
  default = "us-east-1"
}
variable "ingress_ports" {
  type    = list(number)
  default = [22, 8080]
}
variable "az" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "buck" {
  type    = string
  default = "blue-app"
}
