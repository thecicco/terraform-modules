variable "name" {}
variable "size" {}
variable "instance" {
  type = "list"
}
variable "quantity" {
  default = 1
}
variable "volume_type" {
  default = "Top"
}
variable "region" {
  default = "it-mil1"
}
