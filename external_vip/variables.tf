variable "name" {
}
variable "region" {
  default = "it-mil1"
}
variable "network_name" {}
variable "external_vips" {
  type = "list"
}
variable "discovery" {
  default = "false"
}
variable "discovery_port" {
  default = "0"
}
