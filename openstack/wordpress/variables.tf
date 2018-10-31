variable "db_user" {
}

variable "db_password" {
}

variable "db_host" {
}

variable "name" {
}

variable "consul" {
  default = ""
}

variable "consul_port" {
  default = "8500"
}

variable "consul_datacenter" {
}

variable "consul_encrypt" {
}

variable "sec_group" {
  type = "list"
}

variable "keypair" {
}

variable "flavor" {
  default = "e3standard.x3"
}

variable "network_name" {
}

variable "discovery" {
  default = "false"
}

variable "quantity" {
  default = 1
}

variable "external" {
  default = "true"
}

variable "region" {
  default = "it-mil1"
}
